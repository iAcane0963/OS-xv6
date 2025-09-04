#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/param.h"

#define MAXLINE 512

// Reads lines from standard input and executes a command with each line as an argument.
int
main(int argc, char *argv[])
{
  char buf[MAXLINE];
  char *new_argv[MAXARG];
  int i, n;

  // Copy original arguments to the new argv.
  for (i = 1; i < argc; i++) {
    new_argv[i - 1] = argv[i];
  }

  int line_start = 0;
  while ((n = read(0, buf + line_start, sizeof(buf) - line_start)) > 0) {
    int line_end = line_start + n;
    int j = 0;
    for (i = line_start; i < line_end; i++) {
      if (buf[i] == '\n') {
        buf[i] = '\0';
        new_argv[argc - 1] = &buf[j];
        new_argv[argc] = 0;

        // Fork a child process to execute the command.
        if (fork() == 0) {
          exec(new_argv[0], new_argv);
          fprintf(2, "exec failed\n");
          exit(1);
        } else {
          wait(0);
        }
        j = i + 1;
      }
    }
    // Handle case where line is not yet complete.
    if (j > 0) {
      memmove(buf, buf + j, line_end - j);
      line_start = line_end - j;
    } else {
      line_start = line_end;
    }
  }

  exit(0);
}