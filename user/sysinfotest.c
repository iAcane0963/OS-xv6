#include "kernel/types.h"
#include "kernel/sysinfo.h"
#include "user/user.h"

int
main(void)
{
  struct sysinfo info;

  if (sysinfo(&info) < 0) {
    fprintf(2, "sysinfo failed\n");
    exit(1);
  }

  printf("free memory: %d\n", info.freemem);
  printf("nproc: %d\n", info.nproc);

  exit(0);
}

