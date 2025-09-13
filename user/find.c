#include "kernel/types.h"  // 包含xv6内核的基本类型定义
#include "kernel/stat.h"   // 包含文件状态信息的结构体定义，如 struct stat
#include "user/user.h"     // 包含用户程序可用的函数原型和宏定义
#include "kernel/fs.h"     // 包含文件系统的相关定义，如 DIRSIZ 和 struct dirent

// 递归查找函数
// path: 当前查找的路径
// name: 要查找的文件名
void
find(char *path, char *name)
{
  char buf[512], *p; // buf 用于构建新的路径, p 是一个指针，用于操作路径字符串
  int fd; // 文件描述符
  struct dirent de; // 目录项结构体，用于读取目录内容
  struct stat st;   // 文件状态结构体

  // 打开路径对应的文件或目录
  if((fd = open(path, 0)) < 0){
    fprintf(2, "find: cannot open %s\n", path);
    return;
  }

  // 获取文件或目录的状态信息
  if(fstat(fd, &st) < 0){
    fprintf(2, "find: cannot stat %s\n", path);
    close(fd);
    return;
  }

  // 根据文件类型进行处理
  switch(st.type){
  case T_FILE:
    // 如果是文件类型，需要从路径中提取出文件名进行比较。
    // 注意：下面的提取逻辑对于根目录下的文件（如 "/a"）可能无法正确工作。
    
    // p 指向路径的最后一个非'/'字符
    p = path + strlen(path) - 1;
    while(*p == '/') p--;
    // p 向前移动，直到遇到'/'或者路径的开头
    while(p > path && *p != '/') p--;
    // 如果p没有停在路径的开头，说明前面有'/'，此时p需要向后移动一位指向文件名
    if(p != path) p++;

    // 比较提取出的文件名和目标文件名
    if(strcmp(p, name) == 0){
      printf("%s\n", path); // 如果匹配，打印完整路径
    }
    break;

  case T_DIR:
    // 如果是目录类型，递归地在目录中查找
    // 检查路径长度是否会超出缓冲区
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
      printf("find: path too long\n");
      break;
    }
    // 将当前目录路径拷贝到缓冲区
    strcpy(buf, path);
    p = buf + strlen(buf);
    *p++ = '/'; // 在路径末尾添加'/'

    // 读取目录中的每一个目录项
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
      if(de.inum == 0) continue; // 跳过无效的目录项
      // 跳过 "." 和 ".." 目录，防止无限递归
      if(strcmp(de.name, ".") == 0 || strcmp(de.name, "..") == 0) continue;

      // 将读取到的目录项名字拷贝到路径末尾，构成新路径
      strcpy(p, de.name);
      // 递归调用 find，在新的路径下继续查找
      find(buf, name);
    }
    break;
  }
  close(fd); // 关闭文件描述符
}

int
main(int argc, char *argv[])
{
  // 检查命令行参数是否为3个 (程序名、路径、文件名)
  if(argc != 3){
    fprintf(2, "Usage: find <path> <name>\n");
    exit(1);
  }

  // 调用 find 函数开始查找
  find(argv[1], argv[2]);
  exit(0);
}