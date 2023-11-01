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
#define FREEPROB 50 
#define PERCENT 100
#define BLKMAX 16384
#define MAX_THRDS 4


RTTTHREAD threadCreate(void *arg) {
    long myId;
    int size;
    int probability;
    LIST* blocks;
    memBlock* block;
    int randFree;
    int i;


    myId = (long) arg;

    blocks = ListCreate();

    for(;;) {
        size = rand() % BLKMAX; 
        probability = (rand() % PERCENT) + 1;
        if (probability > FREEPROB) {
            printf("%ld start allocate\n", myId);
            if(size != 0) {
                printf("Allocating\n");
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
                printf("Freeing\n");
                if (0 == Free(block->startAddr)) {
                    ListRemove(blocks);
                }
            }
        }
        memPrinter();
        RttSleep((int) (rand() % SLEEP));
    }
}


int mainp() {
    int thread;
    RttSchAttr attr;
    RttThreadId id;
    int i;

    attr.startingtime = RTTZEROTIME;
    attr.priority = RTTNORM;
    attr.deadline = RTTNODEADLINE;

    /*setbuff(stdout,0);*/

    /*srand(71);*/
    
    BestFitInit();
    for (i = 0; i < MAX_THRDS; i++) {
        thread = RttCreate(&id, threadCreate, STKSIZE,
                           "simProc", NULL, attr, RTTUSR);
        if (thread == RTTFAILED) {
            perror("RttCreate");
        }
    }

    /*printf("Threads created\n");*/

    return(0);

}
