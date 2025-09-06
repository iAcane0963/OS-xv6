#include "types.h"
#include "riscv.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "proc.h"
#include "sysinfo.h"

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

uint64
sys_trace(void)
{
  int mask;
  if(argint(0, &mask) < 0)
    return -1;
  myproc()->trace_mask = mask;
  return 0;
}

uint64
sys_sysinfo(void)
{
  uint64 user_addr;
  struct sysinfo info;

  if (argaddr(0, &user_addr) < 0)
    return -1;

  info.freemem = kmem_free_count();
  info.nproc = proc_count();

  if (copyout(myproc()->pagetable, user_addr, (char *)&info, sizeof(info)) < 0)
    return -1;

  return 0;
}

uint64
sys_pgaccess(void)
{
  uint64 start_addr, user_buf;
  int num_pages;
  struct proc *p = myproc();
  int mask = 0;

  if(argaddr(0, &start_addr) < 0 || argint(1, &num_pages) < 0 || argaddr(2, &user_buf) < 0)
    return -1;

  if (num_pages > 32)
    return -1;

  for (int i = 0; i < num_pages; i++) {
    pte_t *pte = walk_pte(p->pagetable, start_addr + i * PGSIZE);
    if (pte != 0 && (*pte & PTE_A)) {
      mask |= (1 << i);
      *pte &= ~PTE_A; // Clear the accessed bit
    }
  }

  if (copyout(p->pagetable, user_buf, (char *)&mask, sizeof(mask)) < 0)
    return -1;

  return 0;
}
