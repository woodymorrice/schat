/* CMPT332 - Group 14
 * Phong Thanh Nguyen (David) - wdz468 - 11310824
 * Woody Morrice - wam553 - 11071060 */

#include <stdio.h>
#include <rtthreads.h>
#include <RttCommon.h>

#include <list.h>

#include <BestFitMonitor.h>

#define SLEEP 20
#define STKSIZE 65536
#define FREEPROB 60 
#define PERCENT 100
#define BLKMAX 8192
#define MAX_THRDS 8
#define NUM_ITERS 8


RTTTHREAD threadCreate(void* arg) {
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
        RttSleep((int) (rand() % SLEEP));
        
        size = rand() % BLKMAX + 1; 
        probability = (rand() % PERCENT) + 1;
        if (probability > FREEPROB) {
            printf("%ld start allocate\n", myId);
            if(size != 0) {
                block = BFAllocate(size);
                if (block != NULL) {
                    ListPrepend(blocks, block);
                }
            }
        }
        else {
            if (ListCount(blocks) > 0) {
                randFree = rand() % ListCount(blocks)+1;
                ListFirst(blocks);
                for (i = 1; i < randFree; i++) {
                    block = ListNext(blocks);
                }
                printf("%ld start free\n", myId);
                if (0 == Free(block->startAddr)) {
                    ListRemove(blocks);
                }
            }
        }
    }
}


int mainp() {
    int thread;
    RttThreadId id;
    RttSchAttr attr;

    attr.startingtime = RTTZEROTIME;
    attr.priority = RTTNORM;
    attr.deadline = RTTNODEADLINE;

    /*setbuff(stdout,0);*/

    srand(71);
    
    BestFitInit();
    thread = RttCreate(&id, threadCreate, STKSIZE,
                       "simProc", (void*)1, attr, RTTUSR);
    if (thread == RTTFAILED) { perror("RttCreate"); }

    thread = RttCreate(&id, threadCreate, STKSIZE,
                       "simProc", (void*)2, attr, RTTUSR);
    if (thread == RTTFAILED) { perror("RttCreate"); }

    thread = RttCreate(&id, threadCreate, STKSIZE,
                       "simProc", (void*)3, attr, RTTUSR);
    if (thread == RTTFAILED) { perror("RttCreate"); }

    thread = RttCreate(&id, threadCreate, STKSIZE,
                       "simProc", (void*)4, attr, RTTUSR);
    if (thread == RTTFAILED) { perror("RttCreate"); }

    thread = RttCreate(&id, threadCreate, STKSIZE,
                       "simProc", (void*)5, attr, RTTUSR);
    if (thread == RTTFAILED) { perror("RttCreate"); }

    thread = RttCreate(&id, threadCreate, STKSIZE,
                       "simProc", (void*)6, attr, RTTUSR);
    if (thread == RTTFAILED) { perror("RttCreate"); }

    thread = RttCreate(&id, threadCreate, STKSIZE,
                       "simProc", (void*)7, attr, RTTUSR);
    if (thread == RTTFAILED) { perror("RttCreate"); }

    thread = RttCreate(&id, threadCreate, STKSIZE,
                       "simProc", (void*)8, attr, RTTUSR);
    if (thread == RTTFAILED) { perror("RttCreate"); }

    /*printf("Threads created\n");*/

    return(0);

}
