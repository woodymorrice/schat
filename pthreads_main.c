/* CMPT332 - Group 14
 * Phong Thanh Nguyen (David) - wdz468 - 11310824
 * Woody Morrice - wam553 - 11071060 */
#include <standards.h>
#include <os.h>

#include <square.h>

/* the number of args to sent to parentThread */
#define NUMARGS 3

struct htEntry *hTable;

int args[NUMARGS];

PROCESS childProcess() {
    /* Declare variables
     * Record begin time
     * Cast argument and possibly dereference it
     * Check arguments for validity
     * Begin square loop
     * Record end time
     * Calculate elapsed time
     * Exit */
    unsigned long int id;
    int index;
    clock_t endTime;
    int i;
    int sqCalls;
    printf("args: %d, %d, %d\n", args[0], args[1], args[2]);

    id = MyPid();
    index = hashFunc(id);
    hTable[index].beginTime = clock();
    hTable[index].sqCalls = 0;

    for (i = 0; i < args[2]; i++) {
        square(i);
    }

    endTime = hTable[index].beginTime - clock(); 
    sqCalls = hTable[index].sqCalls;

    printf("child %ld\n", id);
    printf("time: %ld\n", endTime);
    printf("square(): %d\n", sqCalls);
}


PROCESS parentProcess() {
    /* Declare variables
     * Cast argument and possibly dereference it
     * Check arguments for validity
     * Loop to create child threads
     * Sleep until deadline
     * Exit */
    int i;
    PID childThread;
    int index;
    printf("args: %d, %d, %d\n", args[0], args[1], args[2]);
  

    for (i = 0; i < args[0]; i++) {
        /* Create child thread */
        childThread = Create( (void(*)()) childProcess, 16384,
            "childThread", NULL, NORM, USR);
        if (childThread == PNUL) {    
            fprintf(stderr,
                "Error in parentThread: Failed to create child thread\n");
        }
        /* Hash its index */
        index = hashFunc(childThread);
        /* Record it's threadId */
        hTable[index].entryId = childThread;

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
   /*  int args[NUMARGS]; */
    hTable = malloc(HT_SIZE*sizeof(struct htEntry));
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

    printf("args: %d, %d, %d\n", args[0], args[1], args[2]);

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
            "parentThread", NULL, NORM, USR);

    if (parentThread == PNUL) {
        fprintf(stderr,
                "Error in %s: Failed to create parent thread\n", argv[0]);
    }

    return EXIT_SUCCESS;
}

