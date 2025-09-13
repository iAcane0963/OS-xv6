#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

/* 线程可能的状态 */
#define FREE        0x0 // 空闲，可被创建
#define RUNNING     0x1 // 正在运行
#define RUNNABLE    0x2 // 可运行，等待被调度

#define STACK_SIZE  8192 // 每个线程的栈大小
#define MAX_THREAD  4    // 最大线程数（包括主线程）

// 用于用户态上下文切换时保存的寄存器
struct context {
  uint64 ra; // 返回地址 (Return Address)
  uint64 sp; // 栈指针 (Stack Pointer)

  // 被调用者保存的寄存器 (Callee-saved registers)
  uint64 s0;
  uint64 s1;
  uint64 s2;
  uint64 s3;
  uint64 s4;
  uint64 s5;
  uint64 s6;
  uint64 s7;
  uint64 s8;
  uint64 s9;
  uint64 s10;
  uint64 s11;
};

// 线程结构体
struct thread {
  char       stack[STACK_SIZE]; // 线程自己的栈空间
  int        state;             // 线程状态 (FREE, RUNNING, RUNNABLE)
  struct context context;         // 线程的上下文（寄存器）
};

// 所有线程的数组
struct thread all_thread[MAX_THREAD];
// 指向当前正在运行的线程的指针
struct thread *current_thread;
// 声明外部的汇编函数 thread_switch
extern void thread_switch(uint64, uint64);


void
thread_init(void)
{
  // main() 函数本身作为第一个线程（线程0）
  // 它需要一个上下文，以便第一次调用 thread_switch 时可以保存状态
  current_thread = &all_thread[0];
  current_thread->state = RUNNING;
}

void
thread_schedule(void)
{
  struct thread *t, *next_thread;

  /* 寻找下一个可运行的线程 */
  next_thread = 0;
  t = current_thread + 1; // 从当前线程的下一个开始寻找
  for(int i = 0; i < MAX_THREAD; i++){
    if(t >= all_thread + MAX_THREAD) // 如果到达数组末尾，则回到开头
      t = all_thread;
    if(t->state == RUNNABLE) { // 找到了一个可运行的线程
      next_thread = t;
      break;
    }
    t = t + 1;
  }

  if (next_thread == 0) {
    printf("thread_schedule: no runnable threads\n");
    exit(-1);
  }

  if (current_thread != next_thread) { // 如果找到了一个不同的线程来运行
    next_thread->state = RUNNING;
    t = current_thread;
    current_thread = next_thread;
    // 调用汇编函数 thread_switch，进行上下文切换
    // 将当前寄存器保存到 t->context 中
    // 从 current_thread->context 中恢复寄存器
    thread_switch((uint64)&t->context, (uint64)&current_thread->context);
  } else
    next_thread = 0;
}

// 创建一个新线程，执行 func 函数
void
thread_create(void (*func)())
{
  struct thread *t;

  // 寻找一个空闲的线程结构体
  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
    if (t->state == FREE) break;
  }
  t->state = RUNNABLE; // 将其状态设置为可运行
  
  // 设置新线程的初始上下文
  // 1. 将返回地址(ra)设置为要执行的函数地址
  //    这样当 thread_switch 第一次恢复此线程的上下文时，`ret` 指令会跳转到 func 执行
  t->context.ra = (uint64)func;
  // 2. 设置栈指针(sp)指向此线程私有栈的顶部
  //    栈是向下增长的，所以指向数组的末尾
  t->context.sp = (uint64)&t->stack[STACK_SIZE];
}


// 线程主动放弃CPU，切换到其他线程
void
thread_yield(void)
{
  // 将当前线程状态从 RUNNING 改为 RUNNABLE
  current_thread->state = RUNNABLE;
  // 调用调度器，选择并切换到一个新的线程
  thread_schedule();
}

// --- 以下是用于测试的线程函数和 main 函数 ---

volatile int a_started, b_started, c_started;
volatile int a_n, b_n, c_n;

void
thread_a(void)
{
  int i;
  printf("thread_a started\n");
  a_started = 1;
  // 等待其他线程开始
  while(b_started == 0 || c_started == 0)
    thread_yield();

  for (i = 0; i < 100; i++) {
    printf("thread_a %d\n", i);
    a_n += 1;
    thread_yield(); // 主动让出，切换到其他线程
  }
  printf("thread_a: exit after %d\n", a_n);

  // 线程结束，将其状态设为空闲，并调用调度器切换到其他线程（不再返回）
  current_thread->state = FREE;
  thread_schedule();
}

void
thread_b(void)
{
  int i;
  printf("thread_b started\n");
  b_started = 1;
  while(a_started == 0 || c_started == 0)
    thread_yield();

  for (i = 0; i < 100; i++) {
    printf("thread_b %d\n", i);
    b_n += 1;
    thread_yield();
  }
  printf("thread_b: exit after %d\n", b_n);

  current_thread->state = FREE;
  thread_schedule();
}

void
thread_c(void)
{
  int i;
  printf("thread_c started\n");
  c_started = 1;
  while(a_started == 0 || b_started == 0)
    thread_yield();

  for (i = 0; i < 100; i++) {
    printf("thread_c %d\n", i);
    c_n += 1;
    thread_yield();
  }
  printf("thread_c: exit after %d\n", c_n);

  current_thread->state = FREE;
  thread_schedule();
}

// 主函数，作为用户线程系统的入口
int
main(int argc, char *argv[])
{
  a_started = b_started = c_started = 0;
  a_n = b_n = c_n = 0;
  thread_init();      // 初始化主线程
  thread_create(thread_a); // 创建线程 a
  thread_create(thread_b); // 创建线程 b
  thread_create(thread_c); // 创建线程 c
  thread_schedule();  // 开始线程调度
  exit(0);
}

