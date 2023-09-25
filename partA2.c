/* CMPT332 - Group 14
 * Phong Thanh Nguyen (David) - wdz468 - 11310824
 * Woody Morrice - wam553 - 11071060 */
#include <standards.h>
#include <os.h>

#include <square.h>

#define NUMARGS 3 /* # of CMD line args */

struct htEntry hTable[HT_SIZE]; /* stores thread info */


PROCESS parentThread(void *argPtr);
PROCESS childThread();
unsigned long int getThrId();


int mainp(int argc, char* argv[]) {
    int args[NUMARGS];          /* pass to thrds */ 
    PID pThread;                /* for checking  */
    int index;

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
            32768, "parentThread", (void*) &args, NORM, USR);
    if (pThread == PNUL) {
        fprintf(stderr,
                "Error in main: failed to create parent thread\n");
    }
    index = hashIn(pThread);
    hTable[index].entryId = pThread;


    /* Do something instead of this
     * Sleep(1000*args[1]+1000); */

    return EXIT_SUCCESS;
}


PROCESS parentThread(void *argPtr) {
    int *args;                  /* ptr to args[] */
    int sq;
    /*PID id;
    int index; */

    args = (int*)argPtr;
    
    /* id = getThrId();
    index = hashIn(id);
    hTable[index].entryId = id; */

    sq = square(1);
    if (sq != 0) {
        printf("Square called successfully from thread\n");
    }
    
}


PROCESS childThread() {
}


unsigned long int getThrId() {
    return MyPid();
}
