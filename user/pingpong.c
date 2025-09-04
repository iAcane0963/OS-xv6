#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
  int p2c[2]; // parent to child
  int c2p[2]; // child to parent
  char buf[1];
  int pid;

  // Create two pipes
  if (pipe(p2c) < 0 || pipe(c2p) < 0) {
    fprintf(2, "pipe failed\n");
    exit(1);
  }

  pid = fork();
  if (pid < 0) {
    fprintf(2, "fork failed\n");
    exit(1);
  }

  if (pid == 0) { // Child process
    close(p2c[1]); // Close write end of parent-to-child pipe
    close(c2p[0]); // Close read end of child-to-parent pipe

    read(p2c[0], buf, 1);
    printf("%d: received ping\n", getpid());
    write(c2p[1], buf, 1);
    close(p2c[0]);
    close(c2p[1]);
  } else { // Parent process
    close(p2c[0]); // Close read end of parent-to-child pipe
    close(c2p[1]); // Close write end of child-to-parent pipe

    write(p2c[1], "a", 1);
    wait(0);
    read(c2p[0], buf, 1);
    printf("%d: received pong\n", getpid());
    close(p2c[1]);
    close(c2p[0]);
  }

  exit(0);
}
