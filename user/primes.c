#include "kernel/types.h"
#include "user/user.h"

void
sieve(int p_read_fd)
{
  int p;
  int n;
  int new_p_read_fd;
  int new_p_write_fd;
  

  // Read the first number from the pipe (which is prime)
  if (read(p_read_fd, &p, sizeof(p)) == 0) {
    close(p_read_fd);
    return;
  }
  printf("prime %d\n", p);

  // Create a new pipe for the next filter
  int new_pipe_fds[2];
  pipe(new_pipe_fds);
  new_p_read_fd = new_pipe_fds[0];
  new_p_write_fd = new_pipe_fds[1];

  int pid = fork();

  if (pid < 0) {
    fprintf(2, "primes: fork failed\n");
    exit(1);
  }

  if (pid == 0) { // Child process
    close(p_read_fd); // Child doesn't need parent's read end
    close(new_p_write_fd); // Child doesn't need its own write end
    sieve(new_p_read_fd);
    close(new_p_read_fd);
    exit(0);

  } else { // Parent process
    close(new_p_read_fd); // Parent doesn't need child's read end

    while (read(p_read_fd, &n, sizeof(n)) > 0) {
      if (n % p != 0) {
        write(new_p_write_fd, &n, sizeof(n));
      }
    }
    close(p_read_fd);
    close(new_p_write_fd);
    wait(0);
    exit(0);
  }
}

int
main(int argc, char *argv[])
{
  int p_fds[2];
  pipe(p_fds);

  int pid = fork();

  if (pid < 0) {
    fprintf(2, "primes: fork failed\n");
    exit(1);
  }

  if (pid == 0) { // Child process
    close(p_fds[1]); // Child doesn't need write end
    sieve(p_fds[0]);
    close(p_fds[0]);
    exit(0);

  } else { // Parent process
    close(p_fds[0]); // Parent doesn't need read end

    for (int i = 2; i <= 35; i++) {
      write(p_fds[1], &i, sizeof(i));
    }
    close(p_fds[1]);
    wait(0);
    exit(0);
  }
}
