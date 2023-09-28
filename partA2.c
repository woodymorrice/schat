/* CMPT332 - Group 14
 * Phong Thanh Nguyen (David) - wdz468 - 11310824
 * Woody Morrice - wam553 - 11071060 */
#include <standards.h>
#include <os.h>

#include <square.h>

struct thrInfo thrArr[NUMTHRDS]; /* stores thread info */

PROCESS parentThread(void *argPtr);
PROCESS childThread(void *argPtr);
unsigned long int getThrId();

int args[NUMARGS];

int mainp(int argc, char* argv[]) {
    PID pThread;

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

    args = (int*)argPtr;
    
    for (i = 0; i < args[0]; i++) {
        id = Create((void(*)())childThread,
                32768, "childThread", (void*)&args, HIGH, USR);
        if (id == PNUL) {
            fprintf(stderr,
                "Error in parentThread: failed to create child thread\n");
        }
        thrArr[i].entryId = (unsigned)id;
        thrArr[i].beginTime = (unsigned)Time();
        thrArr[i].sqCalls = 0;
    }

    Sleep(100*args[1]+10);

    for (i = 0; i < args[0]; i++) {
        if (PExists(thrArr[i].entryId)) {
            printf("childThread %ld killed by parent."
                   " %d square calls, %ld ms\n",
                   thrArr[i].entryId,
                   thrArr[i].sqCalls,
                   (unsigned)Time() - thrArr[i].beginTime);
            Kill(thrArr[i].entryId);
        }
    }

    Pexit();
}


PROCESS childThread(void *argPtr) {
    long unsigned int id;
    int index;
    int *args;
    int i;
    
    id = (unsigned)getThrId();

    for (index = 0; index < (NUMTHRDS - 1) &&
            id != thrArr[index].entryId; index++);

    args = (int*)argPtr;

    printf("%d, %d, %d\n", args[0], args[1], args[2]);

    for (i = 1; i <= args[2]; i++) {
        square(i);
    }

    printf("childThread %ld finished."
           " %d square calls, %ld ms\n",
           thrArr[index].entryId,
           thrArr[index].sqCalls,
           (unsigned)Time() - thrArr[index].beginTime);

    Pexit();
}


unsigned long int getThrId() {
    return MyPid();
}
