// Physical memory allocator, for user processes,
// kernel stacks, page-table pages,
// and pipe buffers. Allocates whole 4096-byte pages.

#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "riscv.h"
#include "defs.h"

// 为 COW 实验添加：每个物理页的引用计数字段。
// 数组的索引是物理地址除以 PGSIZE，即物理页号。
int useReference[PHYSTOP/PGSIZE];
// 为保护引用计数数组的并发访问而设立的锁。
struct spinlock ref_count_lock;

void freerange(void *pa_start, void *pa_end);

extern char end[]; // first address after kernel.
                   // defined by kernel.ld.

struct run {
  struct run *next;
};

struct {
  struct spinlock lock;
  struct run *freelist;
} kmem;

void
kinit()
{
  initlock(&kmem.lock, "kmem");
  // 为 COW 实验添加：初始化引用计数的锁
  initlock(&ref_count_lock, "ref_count_lock");
  freerange(end, (void*)PHYSTOP);
}

void
freerange(void *pa_start, void *pa_end)
{
  char *p;
  p = (char*)PGROUNDUP((uint64)pa_start);
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    kfree(p);
}

// Free the page of physical memory pointed at by v,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    panic("kfree");

  // 为 COW 实验进行的修改：
  // 在释放页面前，先检查其引用计数。
  int temp;
  acquire(&ref_count_lock);
  // 对应页面的引用计数减1。
  useReference[(uint64)pa/PGSIZE] -= 1;
  temp = useReference[(uint64)pa/PGSIZE];
  release(&ref_count_lock);
  // 如果引用计数仍然大于0，说明还有其他进程在使用此页面，
  // 此时不能释放，直接返回。
  if (temp > 0)
    return;

  // 只有当引用计数为0时，才真正地释放物理页面。
  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);

  r = (struct run*)pa;

  acquire(&kmem.lock);
  r->next = kmem.freelist;
  kmem.freelist = r;
  release(&kmem.lock);
}

// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
  struct run *r;

  acquire(&kmem.lock);
  r = kmem.freelist;
  if(r){
    kmem.freelist = r->next;
    // 为 COW 实验进行的修改：
    // 当分配一个新页面时，将其引用计数初始化为1。
    acquire(&ref_count_lock);
    useReference[(uint64)r / PGSIZE] = 1;
    release(&ref_count_lock);
  }
  release(&kmem.lock);

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
  return (void*)r;
}
