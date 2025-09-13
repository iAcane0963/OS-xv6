// Buffer cache.
//
// The buffer cache is a linked list of buf structures holding
// cached copies of disk block contents.  Caching disk blocks
// in memory reduces the number of disk reads and also provides
// a synchronization point for disk blocks used by multiple processes.
//
// Interface:
// * To get a buffer for a particular disk block, call bread.
// * After changing buffer data, call bwrite to write it to disk.
// * When done with the buffer, call brelse.
// * Do not use the buffer after calling brelse.
// * Only one process at a time can use a buffer,
//     so do not keep them longer than necessary.


#include "types.h"
#include "param.h"
#include "spinlock.h"
#include "sleeplock.h"
#include "riscv.h"
#include "defs.h"
#include "fs.h"
#include "buf.h"

struct {
  // 细粒度锁改造：将原来的一个全局锁，改为一个锁数组，
  // 每个哈希桶对应一把自旋锁，以减少多核环境下的锁竞争。
	struct spinlock lock[NBUCKET];
	struct buf buf[NBUF];

  // 细粒度锁改造：将原来的一个 LRU 链表，
  // 改为 NBUCKET 个链表，每个哈希桶维护自己的链表。
	struct buf head[NBUCKET];
} bcache;

void
binit(void)
{
  struct buf *b;

  // 细粒度锁改造：初始化每个哈希桶的自旋锁。
  for (int i=0;i<NBUCKET;i++)
  {
    initlock(&bcache.lock[i], "bcache");
  }

  // 将所有 buffer 初始化，并为每个 buffer 初始化一个睡眠锁。
  // 注意：这里没有将所有 buffer 串成一个大链表，
  // 而是让它们处于离散状态，等待被 bget 分配到具体的哈希桶中。
  bcache.head[0].next = &bcache.buf[0];
  for(b = bcache.buf; b < bcache.buf+NBUF-1; b++){
    b->next = b+1;
    initsleeplock(&b->lock, "buffer");
  }
  initsleeplock(&b->lock, "buffer");
}

void
write_cache(struct buf *take_buf, uint dev, uint blockno)
{
  take_buf->dev = dev;
  take_buf->blockno = blockno;
  take_buf->valid = 0;
  take_buf->refcnt = 1;
  take_buf->time = ticks;
}

// Look through buffer cache for block on device dev.
// If not found, allocate a buffer.
// In either case, return locked buffer.
// Look through buffer cache for block on device dev.
// If not found, allocate a buffer.
// In either case, return locked buffer.
static struct buf*
bget(uint dev, uint blockno)
{
  struct buf *b, *last;
  struct buf *take_buf = 0;
  // 根据 blockno 计算哈希值，确定该块属于哪个桶。
  int id = HASH(blockno);
  // 获取该桶对应的锁，保护该桶的链表。
  acquire(&(bcache.lock[id]));

  // 策略1: 在当前桶中寻找缓存
  // 遍历当前哈希桶的链表。
  b = bcache.head[id].next;
  last = &(bcache.head[id]);
  for(; b; b = b->next, last = last->next)
  {
    // 如果找到了对应的 block (dev 和 blockno 都匹配)
    if(b->dev == dev && b->blockno == blockno)
    {
      b->time = ticks; // 更新最近使用时间
      b->refcnt++;     // 引用计数加1
      release(&(bcache.lock[id])); // 释放桶锁
      acquiresleep(&b->lock);      // 获取这个 buffer 自己的睡眠锁后返回
      return b;
    }
    // 如果遍历过程中发现有未被引用的 buffer，先记下来，作为备用
    if(b->refcnt == 0)
    {
      take_buf = b;
    }
  }

  // 策略2: 如果在本桶没找到，但找到了一个空闲 buffer，则直接使用它
  if(take_buf)
  {
    write_cache(take_buf, dev, blockno); // 初始化 buffer
    release(&(bcache.lock[id]));         // 释放桶锁
    acquiresleep(&(take_buf->lock));     // 获取 buffer 的睡眠锁
    return take_buf;
  }

  // 策略3: “偷取”其他桶的空闲 buffer
  // 如果在本桶中既没找到缓存，也没找到空闲 buffer，就需要从其他桶寻找一个最近最少使用的空闲 buffer。
  release(&(bcache.lock[id])); // 先释放当前桶的锁，避免死锁

  int lock_num = -1;
  uint64 time = __UINT64_MAX__;
  struct buf *tmp;
  struct buf *last_take = 0;
  // 遍历所有哈希桶
  for(int i = 0; i < NBUCKET; ++i)
  {
    // 跳过我们自己的桶
    if(i == id) continue;
    
    acquire(&(bcache.lock[i])); // 锁住要检查的桶

    // 在这个桶里寻找一个 refcnt 为 0 且时间戳最小的 buffer
    for(b = bcache.head[i].next, tmp = &(bcache.head[i]); b; b = b->next,tmp = tmp->next)
    {
      if(b->refcnt == 0)
      {
        if(b->time < time)
        {
          time = b->time;
          last_take = tmp; // 记录要偷取的 buffer 的前一个节点
          take_buf = b;    // 记录要偷取的 buffer
          
          // 如果之前已经在一个不同的桶里找到了备选 buffer，
          // 那么现在可以释放那个桶的锁了，因为我们找到了一个更好的（更旧的）。
          if(lock_num != -1 && lock_num != i && holding(&(bcache.lock[lock_num])))
            release(&(bcache.lock[lock_num]));
          lock_num = i; // 记录我们选中的 buffer 所在的桶的索引
        }
      }
    }
    // 如果在这轮循环中没有选中任何 buffer，说明这个桶没有空闲 buffer，释放它的锁。
    if(lock_num != i)
      release(&(bcache.lock[i]));
  }

  if (!take_buf)
    panic("bget: no buffers"); // 如果遍历完所有桶还是没找到空闲 buffer，系统崩溃

  // 从被“偷”的桶的链表中移除选中的 buffer
  last_take->next = take_buf->next;
  take_buf->next = 0;
  release(&(bcache.lock[lock_num])); // 释放被“偷”的桶的锁

  // 现在需要将偷来的 buffer 添加到我们自己的桶（id号桶）中
  acquire(&(bcache.lock[id])); // 重新获取自己桶的锁
  b = last; // last 是之前遍历时记录的本桶的最后一个节点
  b->next = take_buf;
  write_cache(take_buf, dev, blockno); // 初始化这个 buffer
  release(&(bcache.lock[id])); // 释放自己桶的锁
  
  acquiresleep(&(take_buf->lock)); // 获取这个 buffer 的睡眠锁后返回

  return take_buf;
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
  virtio_disk_rw(b, 1);
}

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("brelse");

  // 释放 buffer 自身的睡眠锁，允许其他进程使用它。
  releasesleep(&b->lock);

  // 获取该 buffer 所属哈希桶的自旋锁，以安全地修改引用计数。
  int h = HASH(b->blockno);
  acquire(&bcache.lock[h]);
  b->refcnt--;
  release(&bcache.lock[h]);
}

// 增加一个 buffer 的引用计数，防止它被回收。
void bpin(struct buf *b)
{
  int bucket_id = b->blockno % NBUCKET;
  acquire(&bcache.lock[bucket_id]);
  b->refcnt++;
  release(&bcache.lock[bucket_id]);
}

// 减少一个 buffer 的引用计数。
void bunpin(struct buf *b)
{
  int bucket_id = b->blockno % NBUCKET;
  acquire(&bcache.lock[bucket_id]);
  b->refcnt--;
  release(&bcache.lock[bucket_id]);
}
