/* CMPT332 - Group 14
 * Phong Thanh Nguyen (David) - wdz468 - 11310824
 * Woody Morrice - wam553 - 11071060 */
#include <standards.h>
#include <os.h>

#include <square.h>

struct thrInfo thrArr[NUMTHRDS]; /* stores thread info */

int mainp(void *argPtr);
PROCESS parentThread(void *argPtr);
PROCESS childThread(void *argPtr);
unsigned long int getThrId();

int args[NUMARGS];

int main(int argc, char* argv[]) {
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

    mainp(argc, argv);
    return EXIT_SUCCESS;
}

int mainp(void *argPtr) {
    int *args;
    PID pThread;

    args = (int*)argPtr;

    pThread = Create((void(*)())parentThread,
            16384, "parentThread", (void*)&args, NORM, USR);
    if (pThread == PNUL) {
        fprintf(stderr,
                "Error in main: failed to create parent thread\n");
    }

    return EXIT_SUCCESS;
}


PROCESS parentThread(void *argPtr) {
    int *args;
    int i;
    PID id;
    int index;
    struct timeval begTime;

    args = (int*)argPtr;
    
    for (i = 0; i < args[0]; i++) {
        id = Create((void(*)())childThread,
                32768, "childThread", (void*)&args, NORM USR);
        if (id == PNUL) {
            fprintf(stderr,
                "Error in parentThread: failed to create child thread\n");
        }
        thrArr[i].entryId = id;
        thrArr[i].beginTime = 0;
        thrArr[i].sqCalls = 0;
    }
    return EXIT_SUCCESS;
}


PROCESS childThread(void *argPtr) {
    PID id;
    int index;
    int *args;
    int i;

    id = getThrId();

    for (index = 0; index <

}


unsigned long int getThrId() {
    return MyPid();
}
