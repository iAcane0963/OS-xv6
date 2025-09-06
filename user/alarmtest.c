#include "kernel/param.h"
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"
#include "kernel/fcntl.h"
#include "kernel/syscall.h"
#include "kernel/memlayout.h"
#include "kernel/riscv.h"

void test0();
void test1();
void test2();
void periodic();

int
main(int argc, char *argv[])
{
	int pid;
	int status;

	pid = fork();
	if (pid == 0) {
		test0();
		test1();
		test2();
		exit(0);
	}

	wait(&status);

	if (status == 0)
		printf("alarmtest: all tests passed\n");
	else
		printf("alarmtest: test %d failed\n", status);

	exit(0);
}

volatile int count;

void
periodic()
{
	count = count + 1;
	printf("alarm!\n");
	sigreturn();
}

// tests whether the kernel calls the alarm handler.
void
test0()
{
	int i;
	printf("test0 start\n");
	count = 0;
	sigalarm(2, periodic);
	for(i = 0; i < 1000*500000; i++){
		if((i % 1000000) == 0)
			write(2, ".", 1);
		if(count > 0)
			break;
	}
	sigalarm(0, 0);
	if(count > 0){
		printf("test0 passed\n");
	} else {
		printf("\ntest0 failed: the kernel never called the alarm handler\n");
		exit(1);
	}
}

void
handler1()
{
	printf("alarm!\n");
	exit(0);
}

// tests whether the kernel calls the alarm handler
// after a fork().
void
test1()
{
	int pid;

	printf("test1 start\n");
	pid = fork();
	if (pid == 0) {
		sigalarm(2, handler1);
		for(;;)
		{
		}
	}

	wait(0);
	printf("test1 passed\n");
}

volatile int count2;

void
handler2()
{
	count2++;
	printf("alarm!\n");
	sigreturn();
}

// tests whether the kernel calls the alarm handler
// multiple times.
void
test2()
{
	int i;

	printf("test2 start\n");
	count2 = 0;
	sigalarm(2, handler2);
	for(i = 0; i < 1000*500000; i++){
		if((i % 1000000) == 0)
			write(2, ".", 1);
		if(count2 >= 5)
			break;
	}
	sigalarm(0, 0);
	if(count2 >= 5){
		printf("test2 passed\n");
	} else {
		printf("\ntest2 failed: alarm handler called %d times, expected >= 5\n", count2);
		exit(2);
	}
}