/* CMPT332 - Group 14
 * Phong Thanh Nguyen (David) - wdz468 - 11310824
 * Woody Morrice - wam553 - 11071060 */
#include <unistd.h>
#include <pthread.h>

#include <square.h>

struct thrInfo thrArr[NUMTHRDS]; /* stores thread info */

void* parentThread(void *argPtr);
void* childThread(void *argPtr);
unsigned long int getThrId();

int args[NUMARGS];

int main(int argc, char* argv[]) { 
    int pThread;                /* for checking  */
    pthread_t id;

    if (argc != 4) {
        /* fprintf(stderr,
                "Error in main: invalid number of parameters\n"); */
        return EXIT_FAILURE;
    } else {
        args[0] = atoi(argv[1]);
        args[1] = atoi(argv[2]);
        args[2] = atoi(argv[3]);
    }

    if (args[0] < 1 ||
        args[1] < 1 ||
        args[2] < 1) {
        return EXIT_FAILURE;
    }

    pThread = pthread_create(&id, NULL, parentThread, (void*)&args);
    if (pThread != 0) {
        fprintf(stderr,
                "Error in main: failed to create parent thread\n");
    }

    sleep(args[1]);
    return EXIT_SUCCESS;
}


void* parentThread(void *argPtr) {
    int *args;
    int i;
    int cThread;
    pthread_t id;
    struct timeval begTime;

    args = (int*)argPtr;

    id = getThrId();

    for (i = 0; i < args[0]; i++) {
        cThread = pthread_create(&id, NULL, childThread, (void*)&args);
        if (cThread != 0) {
            fprintf(stderr,
                "Error in parentThread: failed to create child thread\n");
        }
        thrArr[i].entryId = id;
        thrArr[i].beginTime = 0;
        thrArr[i].sqCalls = 0;
    }
   
    pthread_exit(NULL);
}


void* childThread(void *argPtr) {
    pthread_t id;
    int index;
    int *args;
    int i;

    id = getThrId();

    for (index = 0; index < (NUMTHRDS - 1) &&
            id != thrArr[index].entryId; index++);

    args = (int*)argPtr;

    for (i = 1; i <= args[2]; i++) {
        square(i);
    }

    pthread_exit(NULL);
}


unsigned long int getThrId() {
    return pthread_self();
}
