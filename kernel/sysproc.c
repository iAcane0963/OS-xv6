#include "types.h"
#include "riscv.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "proc.h"
#include "sysinfo.h"

extern int getnproc(void);
extern int getfreemem(void);

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
  // 从用户空间获取第一个参数（掩码）并存入 mask 变量。
  argint(0, &mask);
  // 将获取到的掩码保存到当前进程的 tracemask 字段中。
  myproc()->tracemask = mask;
  // 返回0，代表系统调用成功。
  return 0;
}

uint64
sys_sysinfo(void)
{
  struct proc *p = myproc();
  struct sysinfo st;
  uint64 addr; // 用于存储用户传入的、指向 sysinfo 结构体的指针

  // 调用辅助函数，获取空闲内存和进程数，并填充到内核的结构体中
  st.freemem = getfreemem();
  st.nproc = getnproc();

  // 获取用户传入的地址参数
  if (argaddr(0, &addr) < 0)
      return -1;
  // 将内核中准备好的结构体内容，拷贝到用户空间指定的地址
  if (copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
      return -1;
  return 0;
}
