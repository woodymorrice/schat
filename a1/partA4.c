/* CMPT332 - Group 14
 * Phong Thanh Nguyen (David) - wdz468 - 11310824
 * Woody Morrice - wam553 - 11071060 */
#include <unistd.h>
#include <signal.h>
#include <time.h>

#include <square.h>

struct thrInfo thrArr[NUMTHRDS]; /* stores thread info */
int thrOut[NUMTHRDS];

unsigned long int getThrId();
void cHandler(int n);
int getMs();

int args[NUMARGS];

int main(int argc, char* argv[]) {
    int i;
    struct sigaction sa;
    int index;

    if (argc < 4) {
        return EXIT_FAILURE;
    } else {
        args[0] = atoi(argv[1]);
        args[1] = atoi(argv[2]);
        args[2] = atoi(argv[3]);
    }

    if (args[0] < 1 || 64    < args[0] ||
        args[1] < 1 || 300   < args[1] ||
        args[2] < 1 || 20000 < args[2]) {
        return EXIT_FAILURE;
    }

    /* parent thread code */
    for (i = 0; i < args[0]; i++) {
        thrArr[i].beginTime = getMs();
        thrArr[i].sqCalls = 0;

        if (fork() == 0) {
            index = i;

            sa.sa_handler = cHandler;
            sigaction(SIGTERM, &sa, NULL);
            printf("Child thread #%d created\n", index+1);

            thrArr[index].entryId = getThrId();

            for (i = 1; i <= args[2]; i++) {
                square(i);
            }

            thrOut[index] = 1;

            printf("childThread %ld finished:"
                   "%d square calls, %ld ms\n",
                   thrArr[index].entryId,
                   thrArr[index].sqCalls,
                   getMs() - thrArr[index].beginTime);

            exit(0);
        }
    }
    
    sleep(args[1]);

    for (i = 0; i < args[0]; i++) {
        if (thrOut[i] != 1) {
        kill(thrArr[i].entryId, SIGTERM);
        printf("childThread %ld killed by parent."
               " %d square calls, %ld ms\n",
               thrArr[i].entryId,
               thrArr[i].sqCalls,
               getMs() - thrArr[i].beginTime);
        }
    }

    return EXIT_SUCCESS;
}


unsigned long int getThrId() {
    return getpid();
}


void cHandler(int n) {
    int index;
    long unsigned int id;
    if (n == SIGTERM) {
        id = getThrId();
        for (index = 0; thrArr[index].entryId != id
                && index < args[0]; index++);

        printf("childThread %ld finished:"
               "%d square calls, %ld ms\n",
               thrArr[index].entryId,
               thrArr[index].sqCalls,
               getMs() - thrArr[index].beginTime);
        exit(0);
    }
}


int getMs() {
    struct timespec clock;
    int sec, msec;

    clock_gettime(CLOCK_REALTIME, &clock);
    sec = (clock.tv_sec % 10000) * 1000;
    msec = clock.tv_nsec / 1000000;

    return sec + msec;
}

