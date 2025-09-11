#include "kernel/param.h"
#include "kernel/types.h"
#include "user/user.h"

#define MAX_LINE_LEN 1024

int
main(int argc, char *argv[])
{
  char line[MAX_LINE_LEN];
  char *nargv[MAXARG];
  int i, n;
  int current_arg_idx;

  if (argc < 2) {
    fprintf(2, "Usage: xargs command [initial-args...]\n");
    exit(1);
  }

  // Copy initial arguments
  for (i = 1; i < argc; i++) {
    nargv[i-1] = argv[i];
  }
  current_arg_idx = argc - 1;

  while ((n = read(0, line, MAX_LINE_LEN)) > 0) {
    if (n == MAX_LINE_LEN) {
      fprintf(2, "xargs: input line too long\n");
      exit(1);
    }
    line[n] = '\0'; // Null-terminate the line

    // Parse the line into arguments
    char *p = line;
    char *arg_start;
    int in_arg = 0;

    while (*p != '\0') {
      if (*p == ' ' || *p == '\n' || *p == '\t') {
        *p = '\0'; // Null-terminate current argument
        in_arg = 0;
      } else if (in_arg == 0) {
        arg_start = p;
        in_arg = 1;
        nargv[current_arg_idx++] = arg_start;
        if (current_arg_idx >= MAXARG) {
          fprintf(2, "xargs: too many arguments\n");
          exit(1);
        }
      }
      p++;
    }
    nargv[current_arg_idx] = 0; // Null-terminate the argument list for exec

    if (fork() == 0) {
      exec(nargv[0], nargv);
      fprintf(2, "xargs: exec failed\n");
      exit(1);
    }

    wait(0);
    current_arg_idx = argc - 1; // Reset for next line
  }

  exit(0);
}
