#include "kernel/param.h"
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
  int i;
  char *nargv[MAXARG]; // 用于存储要执行的新命令及其参数

  // 检查命令行参数是否正确
  // 正确用法: trace <mask> <command> [args]
  // argc 至少为 3 (trace, mask, command)
  if(argc < 3 || (argv[1][0] < '0' || argv[1][0] > '9')){
    fprintf(2, "Usage: %s mask command\n", argv[0]);
    exit(1);
  }

  // 调用 trace 系统调用，将字符串形式的掩码转换为整数后传入内核。
  if (trace(atoi(argv[1])) < 0) {
    fprintf(2, "%s: trace failed\n", argv[0]);
    exit(1);
  }
  
  // 准备传递给 exec 的参数数组 nargv
  // 例如，如果命令是 "trace 2 grep hello README", 
  // 那么 nargv 将会是 {"grep", "hello", "README", 0}
  for(i = 2; i < argc && i < MAXARG; i++){
    nargv[i-2] = argv[i];
  }
  // exec 执行新的命令。因为 exec 会重用当前进程的 proc 结构体，
  // 所以我们设置的 tracemask 会被继承，从而实现对新命令的追踪。
  exec(nargv[0], nargv);
  exit(0);
}

