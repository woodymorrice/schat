/* CMPT332 - Group 14
 * Phong Thanh Nguyen (David) - wdz468 - 11310824
 * Woody Morrice - wam553 - 11071060 */

#include <stdio.h>
#include <rtthreads.h>
#include <RttCommon.h>

#include <BestFitMonitor.h>

#define SLEEP 20
#define STKSIZE 65536
#define FREEPROB 50 
#define PERCENT 100

struct memBlock *block;

RTTHREAD threadCreate(void *arg) {
    long myId;
    int size;
    int probability;
    myId = (long) arg;

    for(;;) {
        size = rand(); 
        probability = rand() % PERCENT;
        if ((rand() % PERCENT) > FREEPROB) {
            printf("%ld start allocate\n", myId);
            if(size != 0) {
                printf("Allocating\n");
                Allocate(size);
            }
        }
        else {
            printf("%ld start free\n", myId);
            if (block->startAddress != NULL && block->isFree == 1) {
                prinf("Freeing\n");
                Free(block->startAddress);
            }
            
        }
        RttSleep((int) (rand() % SLEEP));
    }
}


int mainp() {

    int temp;
    RttSchAttr attr;
    RttThreadId threads;

    attr.startingtime = RTTZEROTIME;
    attr.priority = RTTNORM;
    attr.deadline = RTTNODEADLINE;

    setbuff(stdout,0);

    srand(71);
    
    BestInit();
    
    temp = RttCreate(&threads, (void(*)()) threadCreate, STKSIZE, "THR",
                    (void*) 1000 attr, RTTUSR);
    if (temp == RTTFAILED) perror("RttCreate");

    printf("Threads created\n");

    return(0);

}
