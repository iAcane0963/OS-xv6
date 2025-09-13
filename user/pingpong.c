#include "kernel/types.h" // 包含xv6内核的基本类型定义
#include "user/user.h"   // 包含用户程序可用的函数原型和宏定义

int
main(int argc, char *argv[])
{
  // p2c: parent to child pipe
  // c2p: child to parent pipe
  int p2c[2]; // 用于父进程向子进程发送数据的管道
  int c2p[2]; // 用于子进程向父进程发送数据的管道
  char buf[1]; // 缓冲区，用于在管道中传递一个字节的数据

  // 创建两个管道
  pipe(p2c);
  pipe(c2p);

  // 创建子进程
  int pid = fork();

  if (pid < 0) {
    // fork 失败
    fprintf(2, "pingpong: fork failed\n");
    exit(1);
  }

  if (pid == 0) { // 子进程
    // 子进程中，关闭 p2c 管道的写端，因为它只从中读取
    close(p2c[1]);
    // 子进程中，关闭 c2p 管道的读端，因为它只向其中写入
    close(c2p[0]);

    // 从父进程的管道中读取一个字节
    // read 会阻塞，直到父进程写入数据
    if (read(p2c[0], buf, 1) != 1) {
      fprintf(2, "pingpong: child failed to read from pipe\n");
      exit(1);
    }

    // 打印 "ping" 消息
    fprintf(1, "%d: received ping\n", getpid());

    // 向父进程的管道中写入一个字节
    if (write(c2p[1], buf, 1) != 1) {
      fprintf(2, "pingpong: child failed to write to pipe\n");
      exit(1);
    }

    // 关闭剩余的管道文件描述符
    close(p2c[0]);
    close(c2p[1]);
    exit(0);

  } else { // 父进程
    // 父进程中，关闭 p2c 管道的读端，因为它只向其中写入
    close(p2c[0]);
    // 父进程中，关闭 c2p 管道的写端，因为它只从中读取
    close(c2p[1]);

    // 向子进程的管道中写入一个字节 "a"
    if (write(p2c[1], "a", 1) != 1) {
      fprintf(2, "pingpong: parent failed to write to pipe\n");
      exit(1);
    }

    // 从子进程的管道中读取一个字节
    // read 会阻塞，直到子进程写入数据
    if (read(c2p[0], buf, 1) != 1) {
      fprintf(2, "pingpong: parent failed to read from pipe\n");
      exit(1);
    }

    // 打印 "pong" 消息
    fprintf(1, "%d: received pong\n", getpid());

    // 关闭剩余的管道文件描述符
    close(p2c[1]);
    close(c2p[0]);
    // 等待子进程退出
    wait(0);
    exit(0);
  }
}