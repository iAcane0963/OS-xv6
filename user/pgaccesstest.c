#include "kernel/param.h"
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/riscv.h"

void
test_phase(char* buf, int phase, int expected_mask)
{
    int mask;
    if (pgaccess((void*)buf, 32, &mask) < 0) {
        printf("pgaccess failed\n");
        exit(1);
    }
    if (mask != expected_mask) {
        printf("phase %d: FAILED: expected mask %d, got %d\n", phase, expected_mask, mask);
        exit(1);
    }
    printf("phase %d: OK\n", phase);
}

int
main(int argc, char *argv[])
{
    char *buf = sbrk(32 * PGSIZE);

    printf("pgaccesstest starting\n");

    // Initial state: no pages in the new buffer have been accessed
    test_phase(buf, 0, 0);

    // Phase 1: read a page in the buffer
    buf[5 * PGSIZE] = 1;
    test_phase(buf, 1, 1 << 5);

    // Phase 2: write a page in the buffer
    buf[10 * PGSIZE] = 1;
    test_phase(buf, 2, 1 << 10);

    // Phase 3: access multiple pages
    buf[1 * PGSIZE] = 1;
    buf[15 * PGSIZE] = 1;
    buf[25 * PGSIZE] = 1;
    test_phase(buf, 3, (1 << 1) | (1 << 15) | (1 << 25));

    // Phase 4: check that bits were cleared
    test_phase(buf, 4, 0);

    printf("pgaccesstest passed\n");
    exit(0);
}