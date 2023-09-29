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
    int pip[2];
    char* buf[1];
    int pid;

    pipe(pip);
    
    write(pip[1], buf, 1);

    if (fork() == 0) {
        if (read(pip[0], buf, 1) == 1) {
            pid = getpid();
            fprintf(1, "%d: received ping\n", pid);
        }
        write(pip[1], buf, 1);
        exit(0);
    }
    else {
        wait(0);
        if (read(pip[0], buf, 1) == 1) {
            pid = getpid();
            fprintf(1, "%d: received pong\n", pid);
        }
    }
    exit(0);
}

