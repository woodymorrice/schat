/* CMPT332 - Group 14
 * Phong Thanh Nguyen (David) - wdz468 - 11310824
 * Woody Morrice - wam553 - 11071060 */
#include "kernel/types.h"
#include "user/user.h"

/* pingpong -- uses UNIX system calls to "ping-pong" a byte between two
 * processes over a pair of pipes, one for each direction.
 * The parent should send a byte to the child, the child should print
 * "<pid>: received ping", write the byte on the pipe to the parent, and
 * exit. The parent should read the byte form the child, print
 * "<pid>: received pong" and exit. */

int main(int argc, char *argv[]) {
    int pi1[2];     /* parent -> child */
    int pi2[2];     /* child -> parent */
    char buf1;
    char buf2;
    int pid;

    pipe(pi1);
    pipe(pi2);

    buf1 = '0'; /* init'd to '0' for testing */
    buf2 = '0';
    
    /* printf("buffer 1: %c, buffer 2: %c\n", buf1, buf2); */

    write(pi1[1], "1", 1);

    if (fork() == 0) {
        if (read(pi1[0], &buf1, 1) == 1) {
            pid = getpid();
            printf("%d: received ping\n", pid);
            /* printf("buffer 1: %c\n", buf1); */
        }
        else {
            fprintf(2, 
                    "Child did not receive 1 byte\n");
        }
        write(pi2[1], "1", 1);
        exit(0);
    }
    else {
        if (read(pi2[0], &buf2, 1) == 1) {
            pid = getpid();
            printf("%d: received pong\n", pid);
            /* printf("buffer 2: %c\n", buf2); */
        }
        else {
            fprintf(2,
                    "Parent did not receive 1 byte\n");
        }
    }
    exit(0);
}

