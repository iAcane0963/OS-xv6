#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

// The sieve function. It reads a prime from the pipe,
// prints it, and then filters the rest of the numbers.
void
sieve(int read_fd)
{
    int prime;
    int n;
    int p[2];

    // Read the first number from the left pipe. This number is a prime.
    if (read(read_fd, &prime, sizeof(prime)) == 0) {
        close(read_fd);
        exit(0);
    }
    printf("prime %d\n", prime);

    // Create a new pipe for the next stage.
    if (pipe(p) < 0) {
        fprintf(2, "pipe failed\n");
        exit(1);
    }

    int pid = fork();
    if (pid < 0) {
        fprintf(2, "fork failed in child\n");
        exit(1);
    }

    if (pid == 0) { // Child process
        close(read_fd);
        close(p[1]);
        sieve(p[0]);
    } else { // Parent process
        close(p[0]);
        while (read(read_fd, &n, sizeof(n)) > 0) {
            if (n % prime != 0) {
                write(p[1], &n, sizeof(n));
            }
        }
        close(read_fd);
        close(p[1]);
        wait(0);
    }
    exit(0);
}

int
main(int argc, char *argv[])
{
    int p[2];
    int i;

    if (pipe(p) < 0) {
        fprintf(2, "pipe failed\n");
        exit(1);
    }

    int pid = fork();
    if (pid < 0) {
        fprintf(2, "fork failed\n");
        exit(1);
    }

    if (pid == 0) { // Child process
        close(p[1]);
        sieve(p[0]);
    } else { // Parent process
        close(p[0]);
        for (i = 2; i <= 35; i++) {
            write(p[1], &i, sizeof(i));
        }
        close(p[1]);
        wait(0);
    }

    exit(0);
}
