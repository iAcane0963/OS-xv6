#include "kernel/param.h" // 包含内核参数定义，如 MAXARG
#include "kernel/types.h" // 包含xv6内核的基本类型定义
#include "user/user.h"    // 包含用户程序可用的函数原型和宏定义

#define MAX_LINE_LEN 1024 // 定义单次读取内容的最大长度

int
main(int argc, char *argv[])
{
  char line[MAX_LINE_LEN]; // 用于存储从标准输入读取的内容
  char *nargv[MAXARG];     // 传递给 exec 的新参数数组
  int i, n;
  int current_arg_idx;     // nargv 中的当前参数索引

  if (argc < 2) {
    fprintf(2, "Usage: xargs command [initial-args...]\n");
    exit(1);
  }

  // 复制 xargs 命令自身的参数 (除了 "xargs" 本身) 到 nargv
  // 例如: xargs echo hello
  // nargv[0] 会是 "echo", nargv[1] 会是 "hello"
  for (i = 1; i < argc; i++) {
    nargv[i-1] = argv[i];
  }
  current_arg_idx = argc - 1; // 设置从标准输入读取的参数的起始索引

  // 从标准输入 (fd=0) 读取数据块。
  // 注意：这个实现是按块读取和处理，而不是严格按行。
  // 如果一次 read 调用读取了多行，它们会被一起作为参数处理。
  while ((n = read(0, line, MAX_LINE_LEN)) > 0) {
    if (n == MAX_LINE_LEN) {
      fprintf(2, "xargs: input line too long\n");
      exit(1);
    }
    line[n] = '\0'; // 在读取内容的末尾添加空字符，确保它是一个有效的字符串

    // --- 解析从标准输入读取的内容，将其分割成参数 ---
    char *p = line;
    char *arg_start;
    int in_arg = 0; // 标记当前是否正在一个参数内部

    while (*p != '\0') {
      // 如果遇到空白符（空格、换行、制表符）
      if (*p == ' ' || *p == '\n' || *p == '\t') {
        *p = '\0'; // 用空字符替换，从而结束前一个参数字符串
        in_arg = 0;
      } else if (in_arg == 0) {
        // 如果之前不在参数内，并且当前字符不是空白符，说明一个新参数开始了
        arg_start = p; // 记录参数的起始地址
        in_arg = 1;
        nargv[current_arg_idx++] = arg_start; // 将新参数的指针存入 nargv
        if (current_arg_idx >= MAXARG) {
          fprintf(2, "xargs: too many arguments\n");
          exit(1);
        }
      }
      p++;
    }
    // --- 解析结束 ---

    nargv[current_arg_idx] = 0; // 在参数列表末尾添加一个空指针，这是 exec 所要求的

    // 创建子进程来执行命令
    if (fork() == 0) {
      // 子进程调用 exec 来执行命令
      exec(nargv[0], nargv);
      // 如果 exec 成功，它不会返回，下面的代码也不会被执行
      // 如果 exec 失败，打印错误信息并退出子进程
      fprintf(2, "xargs: exec failed\n");
      exit(1);
    }

    // 父进程等待子进程执行完毕
    wait(0);
    // 为下一轮从标准输入读取的内容，重置参数索引
    current_arg_idx = argc - 1; 
  }

  exit(0);
}