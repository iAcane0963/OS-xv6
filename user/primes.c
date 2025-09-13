#include "kernel/types.h" // 包含xv6内核的基本类型定义
#include "user/user.h"   // 包含用户程序可用的函数原型和宏定义

// 筛法函数，用于过滤掉非素数
// p_read_fd: 从左邻进程读取数据的管道文件描述符
void
sieve(int p_read_fd)
{
  int p; // 当前进程处理的素数
  int n; // 从管道中读取的数字
  int new_p_read_fd;  // 用于连接到下一个子进程的管道的读端
  int new_p_write_fd; // 用于连接到下一个子进程的管道的写端
  

  // 从左邻进程的管道中读取第一个数字
  // 这个数字必然是素数，因为它是第一个未被前面筛掉的数
  if (read(p_read_fd, &p, sizeof(p)) == 0) {
    // 如果管道中没有数据可读，说明上一个阶段已经没有数字可以传递了
    // 关闭读端并返回，结束当前进程
    close(p_read_fd);
    return;
  }
  // 打印这个素数
  printf("prime %d\n", p);

  // 创建一个新的管道，用于将当前进程过滤后的数字传递给下一个进程
  int new_pipe_fds[2];
  pipe(new_pipe_fds);
  new_p_read_fd = new_pipe_fds[0];
  new_p_write_fd = new_pipe_fds[1];

  // 创建子进程
  int pid = fork();

  if (pid < 0) {
    fprintf(2, "primes: fork failed\n");
    exit(1);
  }

  if (pid == 0) { // 子进程
    // 子进程不需要从父进程的管道读取数据
    close(p_read_fd);
    // 子进程不需要向自己的管道写入数据
    close(new_p_write_fd);
    // 递归调用 sieve，处理下一个阶段的筛选
    sieve(new_p_read_fd);
    // 子进程的工作完成后，关闭管道的读端
    close(new_p_read_fd);
    exit(0);

  } else { // 父进程 (当前进程) 
    // 父进程不需要从子进程的管道读取数据
    close(new_p_read_fd); 

    // 持续从左邻进程的管道中读取数字
    while (read(p_read_fd, &n, sizeof(n)) > 0) {
      // 如果读取的数字 n 不能被当前素数 p 整除
      if (n % p != 0) {
        // 就将这个数字 n 写入到通往右邻（子进程）的管道中
        write(new_p_write_fd, &n, sizeof(n));
      }
    }
    // 所有数字都读取完毕，关闭与左邻进程的管道
    close(p_read_fd);
    // 所有需要传递的数字都已写入，关闭与右邻进程的管道
    close(new_p_write_fd);
    // 等待子进程结束
    wait(0);
    // 父进程也退出
    exit(0);
  }
}

int
main(int argc, char *argv[])
{
  int p_fds[2]; // 主进程创建的第一个管道
  pipe(p_fds);

  int pid = fork();

  if (pid < 0) {
    fprintf(2, "primes: fork failed\n");
    exit(1);
  }

  if (pid == 0) { // 子进程 (筛选链的第一个进程)
    // 子进程不需要向管道写入
    close(p_fds[1]);
    // 调用 sieve 函数开始筛选
    sieve(p_fds[0]);
    // 工作完成后关闭管道
    close(p_fds[0]);
    exit(0);

  } else { // 父进程 (主进程)
    // 父进程不需要从管道读取
    close(p_fds[0]);

    // 将数字 2 到 35 写入管道
    for (int i = 2; i <= 35; i++) {
      write(p_fds[1], &i, sizeof(i));
    }
    // 写完所有数字后，关闭管道的写端
    // 这会使得子进程的 read 返回 0，从而开始链式反应的终止
    close(p_fds[1]);
    // 等待子进程结束
    wait(0);
    exit(0);
  }
}