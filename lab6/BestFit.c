/* CMPT332 - Group 14
 * Phong Thanh Nguyen (David) - wdz468 - 11310824
 * Woody Morrice - wam553 - 11071060 */

#include <stdio.h>
#include <rtthreads.h>
#include <RttCommon.h>

#include <list.h>

#include <BestFitMonitor.h>

#define MAX_SLEEP 20
#define STKSIZE 65536
#define FREE_PROB 50
#define PERCENT 100
#define TOTAL_MEM 32768
#define MAX_ALLOC 8192
#define MAX_THRDS 4
#define NUM_ITERS 8


RTTTHREAD simProc(void* arg) {
    long myId;
    int size;
    int probability;
    LIST* blocks;
    memBlock* block;
    int randFree;
    int i;
    int j;


    myId = (long)arg;

    blocks = ListCreate();

    for(j = 0; j < NUM_ITERS; j++) { 
        size = (int) ((rand() % MAX_ALLOC) + 1); 
        probability = (int) ((rand() % PERCENT) + 1);
        if (ListCount(blocks) == 0 || probability > FREE_PROB) {
            printf("%ld start allocate\n", myId);
            block = BFAllocate(size);
            if (block != NULL) {
                ListPrepend(blocks, block);
            }
        }
        else {
            if (ListCount(blocks) > 0) {
                randFree = (int) (rand() % ListCount(blocks));
                ListFirst(blocks);
                for (i = 0; i < randFree; i++) {
                    block = ListNext(blocks);
                }
                printf("%ld start free\n", myId);
                if (0 == Free(block->startAddr)) {
                    ListRemove(blocks);
                }
            }
        }
        RttSleep((int) (rand() % MAX_SLEEP));
    }
}


int mainp() {
    int thread;
    RttThreadId id;
    RttSchAttr attr;

    attr.startingtime = RTTZEROTIME;
    attr.priority = RTTNORM;
    attr.deadline = RTTNODEADLINE;

    setbuf(stdout,0);

    srand(71);
    
    BestFitInit();


    printf("Total size: %d\n", TOTAL_MEM);
    memPrinter();

    thread = RttCreate(&id, simProc, STKSIZE,
                       "simProc", (void*)1, attr, RTTUSR);
    if (thread == RTTFAILED) { perror("RttCreate"); }

    RttSleep((int) (rand() % MAX_SLEEP/2));

    thread = RttCreate(&id, simProc, STKSIZE,
                       "simProc", (void*)2, attr, RTTUSR);
    if (thread == RTTFAILED) { perror("RttCreate"); }
    
    RttSleep((int) (rand() % MAX_SLEEP/2));

    thread = RttCreate(&id, simProc, STKSIZE,
                       "simProc", (void*)3, attr, RTTUSR);
    if (thread == RTTFAILED) { perror("RttCreate"); }
    
    RttSleep((int) (rand() % MAX_SLEEP/2));

    thread = RttCreate(&id, simProc, STKSIZE,
                       "simProc", (void*)4, attr, RTTUSR);
    if (thread == RTTFAILED) { perror("RttCreate"); }

    return(0);

}
