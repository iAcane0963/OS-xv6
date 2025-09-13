#include "types.h"
#include "riscv.h"
#include "param.h"
#include "defs.h"
#include "date.h"
#include "memlayout.h"
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
  int n;
  if(argint(0, &n) < 0)
    return -1;
  exit(n);
  return 0;  // not reached
}

uint64
sys_getpid(void)
{
  return myproc()->pid;
}

uint64
sys_fork(void)
{
  return fork();
}

uint64
sys_wait(void)
{
  uint64 p;
  if(argaddr(0, &p) < 0)
    return -1;
  return wait(p);
}

uint64
sys_sbrk(void)
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;

  addr = myproc()->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

uint64
sys_sleep(void)
{
  int n;
  uint ticks0;


  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}


#ifdef LAB_PGTBL
extern pte_t *walk(pagetable_t, uint64, int);

// pgaccess 系统调用的内核实现
int
sys_pgaccess(void)
{
  uint64 srcva; // 用户传入的起始虚拟地址
  uint64 st;    // 用户传入的、用于存储结果的地址
  int len;      // 用户传入的、要检查的页面数量
  uint64 buf = 0; // 内核中的缓冲区，用于构建访问位的掩码
  struct proc *p = myproc();

  // 锁住当前进程，防止在检查页表时，页表被其他地方修改（例如由其他线程）
  acquire(&p->lock);

  // 从用户空间获取参数
  argaddr(0, &srcva); // 第一个参数：起始虚拟地址
  argint(1, &len);    // 第二个参数：要检查的页面数量
  argaddr(2, &st);    // 第三个参数：存储结果的地址

  // 检查页面数量是否在有效范围内（实验要求最多32，但这里是64，也合理）
  if ((len > 64) || (len < 1)){
    release(&p->lock);
    return -1;
  }

  pte_t *pte;
  // 循环检查每个页面
  for (int i = 0; i < len; i++)
  {
    // 使用 walk 函数找到对应虚拟地址的 PTE (页表条目)
    pte = walk(p->pagetable, srcva + i * PGSIZE, 0);
    
    // 检查PTE的有效性
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0){
      // 如果页不存在(walk返回0)，或PTE无效(V=0)，或不是用户页(U=0)，则出错
      release(&p->lock);
      return -1;
    }

    // 检查 PTE_A (Accessed) 访问位
    if(*pte & PTE_A){
      // 如果该页被访问过 (PTE_A == 1)
      // 1. 清除访问位，以便下次可以重新检测
      *pte = *pte & ~PTE_A;
      // 2. 在我们的结果掩码 buf 的对应位上置 1
      buf |= (1 << i);
    }
  }
  release(&p->lock);

  // 将包含结果的 buf 拷贝回用户空间指定的地址 st
  // 注意拷贝的长度，因为 buf 是 uint64，所以根据 len 决定拷贝 1 到 8 个字节
  copyout(p->pagetable, st, (char *)&buf, ((len -1) / 8) + 1);
  return 0;
}
#endif

uint64
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
  return kill(pid);
}

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}
