//
// test program for the alarm lab.
// you can modify this file for testing,
// but please make sure your kernel
// modifications pass the original
// versions of these tests.
//

#include "kernel/param.h"
#include "kernel/types.h"
#include "kernel/stat.h"
#include "kernel/riscv.h"
#include "user/user.h"

void test0();
void test1();
void test2();
void periodic();
void slow_handler();

int
main(int argc, char *argv[])
{
  test0();
  test1();
  test2();
  exit(0);
}

volatile static int count;

// 警报处理函数
void
periodic()
{
  count = count + 1;
  printf("alarm!\n");
  // 关键：处理函数执行完毕后，必须调用 sigreturn() 系统调用
  // 来通知内核并恢复到被中断的程序点继续执行。
  sigreturn();
}

// 测试0: 测试警报处理函数是否至少能被调用一次
void
test0()
{
  int i;
  printf("test0 start\n");
  count = 0;
  // 设置每2个ticks触发一次警报，处理函数为 periodic
  sigalarm(2, periodic);
  // 执行一个大循环，等待 count 变量被 periodic 函数改变
  for(i = 0; i < 1000*500000; i++){
    if((i % 1000000) == 0)
      write(2, ".", 1);
    if(count > 0)
      break;
  }
  // 关闭警报
  sigalarm(0, 0);
  if(count > 0){
    printf("test0 passed\n");
  } else {
    printf("\ntest0 failed: the kernel never called the alarm handler\n");
  }
}

void __attribute__ ((noinline)) foo(int i, int *j) {
  if((i % 2500000) == 0) {
    write(2, ".", 1);
  }
  *j += 1;
}

// 测试1: 测试处理函数能否被多次调用，以及从处理函数返回后，
// 程序能否在正确的点、带着正确的寄存器状态继续执行。
void
test1()
{
  int i;
  int j;

  printf("test1 start\n");
  count = 0;
  j = 0;
  sigalarm(2, periodic);
  for(i = 0; i < 500000000; i++){
    if(count >= 10) // 等待处理函数被调用10次
      break;
    foo(i, &j);
  }
  if(count < 10){
    printf("\ntest1 failed: too few calls to the handler\n");
  } else if(i != j){
    // 如果 i != j，说明从警报处理函数返回时，寄存器 i 或 j 的值没有被正确恢复
    printf("\ntest1 failed: foo() executed fewer times than it was called\n");
  } else {
    printf("test1 passed\n");
  }
}

// 测试2: 测试警报处理函数的不可重入性。
// 即在一个警报处理函数执行期间，不应该再次进入警报处理函数。
void
test2()
{
  int i;
  int pid;
  int status;

  printf("test2 start\n");
  if ((pid = fork()) < 0) {
    printf("test2: fork failed\n");
  }
  if (pid == 0) {
    count = 0;
    // 设置一个执行时间很长的处理函数 slow_handler
    sigalarm(2, slow_handler);
    // 等待，确保时钟中断会再次发生
    for(i = 0; i < 1000*500000; i++){
      if((i % 1000000) == 0)
        write(2, ".", 1);
      if(count > 0)
        break;
    }
    if (count == 0) {
      printf("\ntest2 failed: alarm not called\n");
      exit(1);
    }
    exit(0);
  }
  wait(&status);
  if (status == 0) {
    printf("test2 passed\n");
  }
}

// 一个执行时间很长的处理函数
void
slow_handler()
{
  count++;
  printf("alarm!\n");
  // 如果 count > 1，说明处理函数被重入了，测试失败
  if (count > 1) {
    printf("test2 failed: alarm handler called more than once\n");
    exit(1);
  }
  // 长循环，模拟耗时操作
  for (int i = 0; i < 1000*500000; i++) {
    asm volatile("nop"); // avoid compiler optimizing away loop
  }
  sigalarm(0, 0);
  sigreturn();
}

