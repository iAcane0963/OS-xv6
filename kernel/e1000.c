#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "riscv.h"
#include "spinlock.h"
#include "proc.h"
#include "defs.h"
#include "e1000_dev.h"
#include "net.h"

#define TX_RING_SIZE 16
static struct tx_desc tx_ring[TX_RING_SIZE] __attribute__((aligned(16)));
static struct mbuf *tx_mbufs[TX_RING_SIZE];

#define RX_RING_SIZE 16
static struct rx_desc rx_ring[RX_RING_SIZE] __attribute__((aligned(16)));
static struct mbuf *rx_mbufs[RX_RING_SIZE];

// remember where the e1000's registers live.
static volatile uint32 *regs;

struct spinlock e1000_lock;

// by pci_init().
// xregs is the memory address at which the
// e1000's registers are mapped.
void
e1000_init(uint32 *xregs)
{
  int i;

  initlock(&e1000_lock, "e1000");

  regs = xregs;

  // 重置设备，清除所有之前的设置
  regs[E1000_IMS] = 0; // 禁用所有中断
  regs[E1000_CTL] |= E1000_CTL_RST; // 发出设备重置命令
  regs[E1000_IMS] = 0; // 再次禁用中断，确保重置后状态干净
  __sync_synchronize();

  // [E1000 14.5] 发送部分初始化
  // 清空发送描述符环形缓冲区
  memset(tx_ring, 0, sizeof(tx_ring));
  for (i = 0; i < TX_RING_SIZE; i++) {
    // 将每个描述符的状态都设置为 DD (Descriptor Done)，表示它们是空闲的
    tx_ring[i].status = E1000_TXD_STAT_DD;
    tx_mbufs[i] = 0; // 对应的 mbuf 指针为空
  }
  // 告诉硬件发送环的物理地址
  regs[E1000_TDBAL] = (uint64) tx_ring;
  if(sizeof(tx_ring) % 128 != 0)
    panic("e1000");
  // 设置发送环的长度（字节）
  regs[E1000_TDLEN] = sizeof(tx_ring);
  // 将发送环的头指针和尾指针都初始化为0
  regs[E1000_TDH] = regs[E1000_TDT] = 0;

  // [E1000 14.4] 接收部分初始化
  // 清空接收描述符环形缓冲区
  memset(rx_ring, 0, sizeof(rx_ring));
  for (i = 0; i < RX_RING_SIZE; i++) {
    // 为每个接收描述符预先分配一个 mbuf，用于存放即将到来的数据包
    rx_mbufs[i] = mbufalloc(0);
    if (!rx_mbufs[i])
      panic("e1000");
    // 将描述符的地址字段指向 mbuf 的数据区
    rx_ring[i].addr = (uint64) rx_mbufs[i]->head;
  }
  // 告诉硬件接收环的物理地址
  regs[E1000_RDBAL] = (uint64) rx_ring;
  if(sizeof(rx_ring) % 128 != 0)
    panic("e1000");
  // 接收环的头指针初始化为0
  regs[E1000_RDH] = 0;
  // 接收环的尾指针初始化为环的最后一个描述符，这样硬件就可以使用整个环
  regs[E1000_RDT] = RX_RING_SIZE - 1;
  // 设置接收环的长度（字节）
  regs[E1000_RDLEN] = sizeof(rx_ring);

  // 设置 MAC 地址过滤器，只接收发往本机 MAC 地址的包
  // qemu 默认的 MAC 地址是 52:54:00:12:34:56
  regs[E1000_RA] = 0x12005452;
  regs[E1000_RA+1] = 0x5634 | (1<<31); // (1<<31) 表示地址有效
  // 清空多播表
  for (int i = 0; i < 4096/32; i++)
    regs[E1000_MTA + i] = 0;

  // 配置发送控制寄存器 (TCTL)
  regs[E1000_TCTL] = E1000_TCTL_EN |  // 启用发送功能
    E1000_TCTL_PSP |                  // 填充短数据包
    (0x10 << E1000_TCTL_CT_SHIFT) |   // 冲突阈值
    (0x40 << E1000_TCTL_COLD_SHIFT); // 冲突距离
  regs[E1000_TIPG] = 10 | (8<<10) | (6<<20); // 设置帧间间隙

  // 配置接收控制寄存器 (RCTL)
  regs[E1000_RCTL] = E1000_RCTL_EN | // 启用接收功能
    E1000_RCTL_BAM |                 // 允许广播包
    E1000_RCTL_SZ_2048 |             // 接收缓冲区大小为2048字节
    E1000_RCTL_SECRC;                // 剥离 CRC 校验码

  // 启用接收中断
  regs[E1000_RDTR] = 0; // 无延迟，收到包立即中断
  regs[E1000_RADV] = 0; // 无延迟
  regs[E1000_IMS] = (1 << 7); // 只启用 RXDW (接收描述符写回) 中断
}

int
e1000_transmit(struct mbuf *m)
{
  acquire(&e1000_lock);

  // 读取硬件记录的下一个要处理的发送描述符索引 (Transmit Descriptor Tail)
  uint32 idx = regs[E1000_TDT];

  // 检查该描述符是否空闲。如果不空闲（即硬件还没处理完上次的发送任务），
  // 说明发送队列已满，返回错误。
  if (tx_ring[idx].status != E1000_TXD_STAT_DD)
  {
    release(&e1000_lock);
    return -1;
  } else {
    // 如果之前的 mbuf 存在，则释放它。这对应于上上次的发送任务，
    // 因为硬件处理完一个描述符后，我们才可以在下一轮发送时安全地释放它。
    if (tx_mbufs[idx] != 0)
    {
      mbuffree(tx_mbufs[idx]);
    }
    // 将要发送的 mbuf 存起来，以便将来释放
    tx_mbufs[idx] = m;
    // 将描述符的地址指向 mbuf 的数据区
    tx_ring[idx].addr = (uint64) m->head;
    // 设置要发送的数据长度
    tx_ring[idx].length = (uint16) m->len;
    // 设置命令标志：
    // E1000_TXD_CMD_RS: 请求状态报告，当描述符被处理后，硬件会写回状态
    // E1000_TXD_CMD_EOP: 包结束标志 (End of Packet)
    tx_ring[idx].cmd = E1000_TXD_CMD_RS | E1000_TXD_CMD_EOP;
    
    // 更新 TDT 寄存器，告诉硬件可以处理这个新的描述符了。
    // 索引在环形缓冲区中循环。
    regs[E1000_TDT] = (regs[E1000_TDT] + 1) % TX_RING_SIZE;
  }

  release(&e1000_lock);
  return 0;
}

extern void net_rx(struct mbuf *);
static void
e1000_recv(void)
{
  // 从 RDT (Receive Descriptor Tail) 寄存器的下一个位置开始检查，
  // 因为 RDT 指向的是最后一个被内核处理过的描述符。
  uint32 idx = (regs[E1000_RDT] + 1) % RX_RING_SIZE;
  struct rx_desc* dest = &rx_ring[idx];

  // 循环检查接收环，看是否有新的数据包到达。
  // 硬件在收到一个包并将其放入 mbuf 后，会将描述符的 status 字段的 DD 位设为1。
  while (rx_ring[idx].status & E1000_RXD_STAT_DD)
  {
    acquire(&e1000_lock);
    // 取出包含新数据的 mbuf
    struct mbuf *buf = rx_mbufs[idx];
    // 根据描述符中的长度信息，更新 mbuf 的长度字段
    mbufput(buf, dest->length);

    // 为这个描述符分配一个新的 mbuf，以备接收下一个数据包
    if (!(rx_mbufs[idx] = mbufalloc(0)))
      panic("mbuf alloc failed");
    // 更新描述符，使其指向新的 mbuf
    dest->addr = (uint64)rx_mbufs[idx]->head;
    // 清除描述符的状态，以便硬件可以再次使用它
    dest->status = 0;

    // 更新 RDT 寄存器，告诉硬件我们已经处理到了这个描述符，
    // 这样硬件就可以重新使用它之前的描述符了。
    regs[E1000_RDT] = idx;
    release(&e1000_lock);

    // 将收到的数据包（mbuf）递交给上层网络协议栈处理
    net_rx(buf);

    // 继续检查下一个描述符
    idx = (regs[E1000_RDT] + 1) % RX_RING_SIZE;
    dest = &rx_ring[idx];
  }
}


void
e1000_intr(void)
{
  // tell the e1000 we've seen this interrupt;
  // without this the e1000 won't raise any
  // further interrupts.
  regs[E1000_ICR] = 0xffffffff;

  e1000_recv();
}
