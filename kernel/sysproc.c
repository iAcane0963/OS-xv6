#include "types.h"
#include "riscv.h"
#include "defs.h"
#include "date.h"
#include "param.h"
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
  backtrace();

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
sys_sigalarm(void)
{
	int ticks;
	uint64 handler;
	struct proc *p = myproc();

	// 从用户空间获取第一个参数（间隔 tick 数）和第二个参数（处理函数地址）
	if(argint(0, &ticks) < 0 || argaddr(1, &handler) < 0)
	return -1;

	// 将这些值保存到当前进程的 proc 结构体中
	p->alarminterval = ticks;
	p->alarmhandler = (void (*)())handler;
	// 每次设置新的警报时，都将当前 tick 计数器清零
	p->alarmticks = 0;
	return 0;
}

// 用户空间的警报处理函数执行完毕后，调用此系统调用，通知内核并恢复现场
uint64
sys_sigreturn(void)
{
  struct proc *p = myproc();
  // 设置标记，允许下一次时钟中断触发警报
  p->sigreturned = 1;
  // 从之前保存的 alarmtrapframe 中恢复寄存器状态
  *(p->trapframe) = p->alarmtrapframe;
  // 调用 usertrapret 返回用户空间，此时会使用已恢复的 trapframe
  usertrapret();
  return 0;
}

