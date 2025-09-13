#include "kernel/types.h" // 包含xv6内核的基本类型定义
#include "user/user.h"   // 包含用户程序可用的函数原型和宏定义，如 sleep(), exit(), fprintf(), atoi()

int
main(int argc, char *argv[])
{
  // 检查命令行参数数量是否正确
  // argc 应该是 2，一个是程序名 "sleep"，另一个是需要睡眠的时间
  if(argc != 2){
    // 如果参数数量不为2，则向标准错误输出提示信息
    fprintf(2, "Usage: sleep <ticks>\n");
    // 并以状态码1退出程序，表示出错
    exit(1);
  }

  // 使用 atoi 函数将字符串形式的命令行参数（睡眠时间）转换为整数
  int ticks = atoi(argv[1]);

  // 检查转换后的时间是否为正数
  if(ticks <= 0){
    // 如果时间小于等于0，则向标准错误输出错误信息
    fprintf(2, "sleep: invalid ticks \"%s\"\n", argv[1]);
    // 并以状态码1退出程序
    exit(1);
  }

  // 调用系统调用 sleep，让程序暂停指定的 ticks 数量
  // sleep 函数是在 user/user.h 中声明，在 user/usys.S 中实现的用户级桩函数，最终会陷入内核执行 sys_sleep
  sleep(ticks);

  // 程序正常结束，以状态码0退出
  exit(0);
}