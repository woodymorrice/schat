/* CMPT332 - Group 14
 * Phong Thanh Nguyen (David) - wdz468 - 11310824
 * Woody Morrice - wam553 - 11071060 */
#include <unistd.h>
#include <pthread.h>
#include <signal.h>
#include <time.h>

#include <square.h>

struct thrInfo thrArr[NUMTHRDS]; /* stores thread info */
int thrOut[NUMTHRDS];

void* parentThread(void *argPtr);
void* childThread(void *argPtr);
unsigned long int getThrId();
void cHandler(int n);
int getMs();

int args[NUMARGS];

int main(int argc, char* argv[]) { 
    pthread_t id;

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

    if (0 != pthread_create(&id, NULL, 
             parentThread, (void*)&args)) {
        fprintf(stderr, "Error creating parent thread\n");
    }

    sleep(args[1]+2);
    return EXIT_SUCCESS;
}


void* parentThread(void *argPtr) {
    int *args;
    int i;

    args = (int*)argPtr;

    for (i = 0; i < args[0]; i++) {
        thrArr[i].beginTime = getMs();
        thrArr[i].sqCalls = 0;
        if (0 != pthread_create(&(thrArr[i].entryId),
                 NULL, childThread, (void*)args)) {
            fprintf(stderr, "Error creating child thread\n");
        }
    }

    sleep(args[1]);

    for (i = 0; i < args[0]; i++) {
        if (thrOut[i] != 1) {
        pthread_kill(thrArr[i].entryId, SIGTERM);
        printf("Child %ld killed by parent: "
               "%d square calls, %ld ms\n",
               thrArr[i].entryId,
               thrArr[i].sqCalls,
               getMs() - thrArr[i].beginTime);
        }
    }

    pthread_exit(NULL);
}


void* childThread(void *argPtr) {
    struct sigaction sa;
    int *args;
    long unsigned int id;
    int index;
    int i;

    sa.sa_handler = cHandler;
    sigaction(SIGTERM, &sa, NULL);

    args = (int*)argPtr;

    id = getThrId();

    for (index = 0; thrArr[index].entryId != id &&
            index < args[0]; index++);

    for (i = 1; i <= args[2]; i++) {
        square(i);
    }

    thrOut[index] = 1;

    printf("Child %ld finished: "
           "%d square calls, %ld ms\n",
            id, thrArr[index].sqCalls,
            getMs() - thrArr[index].beginTime);

    pthread_exit(NULL);
}


unsigned long int getThrId() {
    return pthread_self();
}

void cHandler(int n) {
    if (n == SIGTERM) {
        pthread_exit(NULL);
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
