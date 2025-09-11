#include "kernel/types.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
  int p2c[2]; // Pipe for parent to child
  int c2p[2]; // Pipe for child to parent
  char buf[1];

  pipe(p2c);
  pipe(c2p);

  int pid = fork();

  if (pid < 0) {
    fprintf(2, "pingpong: fork failed\n");
    exit(1);
  }

  if (pid == 0) { // Child process
    close(p2c[1]); // Close write end of parent-to-child pipe
    close(c2p[0]); // Close read end of child-to-parent pipe

    if (read(p2c[0], buf, 1) != 1) {
      fprintf(2, "pingpong: child failed to read from pipe\n");
      exit(1);
    }

    fprintf(1, "%d: received ping\n", getpid());

    if (write(c2p[1], buf, 1) != 1) {
      fprintf(2, "pingpong: child failed to write to pipe\n");
      exit(1);
    }

    close(p2c[0]);
    close(c2p[1]);
    exit(0);

  } else { // Parent process
    close(p2c[0]); // Close read end of parent-to-child pipe
    close(c2p[1]); // Close write end of child-to-parent pipe

    if (write(p2c[1], "a", 1) != 1) {
      fprintf(2, "pingpong: parent failed to write to pipe\n");
      exit(1);
    }

    if (read(c2p[0], buf, 1) != 1) {
      fprintf(2, "pingpong: parent failed to read from pipe\n");
      exit(1);
    }

    fprintf(1, "%d: received pong\n", getpid());

    close(p2c[1]);
    close(c2p[0]);
    wait(0);
    exit(0);
  }
}
