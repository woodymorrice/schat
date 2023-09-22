/* CMPT332 - Group 14
 * Phong Thanh Nguyen (David) - wdz468 - 11310824
 * Woody Morrice - wam553 - 11071060 */

#include <stdio.h>
#include <stdlib.h>

#include <standards.h>
#include <os.h>

#include <square.h>

/* the number of args to sent to parentThread */
#define NUMARGS 3

struct htEntry hTable[HT_SIZE];


PROCESS childProcess(void *arg) {
    /* Declare variables
     * Record begin time
     * Cast argument and possibly dereference it
     * Check arguments for validity
     * Begin square loop
     * Record end time
     * Calculate elapsed time
     * Exit */
    

}


PROCESS parentProcess(void *arg) {
    /* Declare variables
     * Cast argument and possibly dereference it
     * Check arguments for validity
     * Loop to create child threads
     * Sleep until deadline
     * Exit */
    int *args;
    int i;
    PID childThread;
    int index;

    args = (int*) arg;

    if (args[0] < 0) {
        fprintf(stderr,
                "Error in parentProcess: Argument 1 \"threads\" must be a positive integer\n");
    }
    if (args[1] < 0) {
        fprintf(stderr,
                "Error in parentProcess: Argument 2 \"deadline\" must be a positive integer\n");
    }
    if (args[2] < 0) {
        fprintf(stderr,
                "Error in parentProcess: Argument 3 \"size\" must be a positive integer\n");
    }

    for (i = 0; i < args[0]; i++) {
        /* Create child thread */
        childThread = Create( (void(*)()) childProcess, 16384,
            "childThread", (void*) args, NORM, USR);
        /* Hash its index */
        index = hashFunc(childThread);
        /* Record it's threadId */
        hTable[index].entryId = childThread;
        hTable[index].sqCalls = 0;

    }

}


int mainp(int argc, char* argv[]) {
    /* Declare variables
     * Check arguments for validity
     * Add arguments to array
     * Create parent thread
     * Ensure parent thread not NULL
     * Exit */
    /* array of args to pass to parentThread */
    int args[NUMARGS];
    PID parentThread;


    if (argc != 4) {
        fprintf(stderr,
                "Error in %s: Incorrect number of command line parameters\n", argv[0]);
    }

    if (argc == 4) {
        args[0] = atoi(argv[1]);
        args[1] = atoi(argv[2]);
        args[2] = atoi(argv[3]);
    }

    if (args[0] < 0) {
        fprintf(stderr,
                "Error in %s: Argument 1 \"threads\" must be a positive integer\n", argv[0]);
    }
    if (args[1] < 0) {
        fprintf(stderr,
                "Error in %s: Argument 2 \"deadline\" must be a positive integer\n", argv[0]);
    }
    if (args[2] < 0) {
        fprintf(stderr,
                "Error in %s: Argument 3 \"size\" must be a positive integer\n", argv[0]);
    }

    parentThread = Create( (void(*)()) parentProcess, 32768,
            "parentThread", (void*) args, NORM, USR);

    if (parentThread == PNUL) {
        fprintf(stderr,
                "Error in %s: Failed to create parent thread\n", argv[0]);
    }

    return EXIT_SUCCESS;
}

