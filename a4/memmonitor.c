/* CMPT332 - Group 14
 * Phong Thanh Nguyen (David) - wdz468 - 11310824
 * Woody Morrice - wam553 - 11071060 */

/* All the list source code files on the behalf of: 
 * Joseph Medernach, imy309, 11313955
 * John Miller, knp254, 11323966
 */ 


#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

#include <monitor.h>
#include <list.h>
#include <memmonitor.h>

/* Total memory for this simulation will be 8 gbs (8,589,934,592 or
 * 2^33 bytes), but since the minimum allocation will be 1 mb (1,048,576
 * or 2^20 bytes), we will reduce the scale by dividing the total memory
 * by the size of the smallest possible allocation: 2^33/2^20 = 2^13 or
 * 8192 and we will use that to represent our total memory size. So 1
 * will represent 1 mb, 2 = 2 mb, and so on. */

#define TOTAL_MEM 8192
#define CONDS 1 /* number of conditions variables */
#define MEM_AVAIL 0

static memStruct* bestMem;
static memStruct* firstMem;

int bestInit() {
    memBlock* init;

    /* init monitor */
    RttMonInit(CONDS);

    /* init memory structure */
    bestMem = malloc(sizeof(memStruct));
    bestMem->blocks = ListCreate();
    bestMem->nFree = 1;
    bestMem->nUsed = 0;
    bestMem->maxSize = 8192;
    bestMem->freeSpace = 8192;
    bestMem->usedSpace = 0;
    bestMem->nOps = 0;


    /* Create initial block of memory */
    init = malloc(sizeof(memBlock));
    init->isFree = true;
    init->startAddr = 0;
    init->size = TOTAL_MEM;

    ListPrepend(bestMem->blocks, init);

    return EXIT_SUCCESS; 
}

int firstInit() {
    memBlock* init;

    /* init monitor */
    RttMonInit(CONDS);

    /* init memory structure */
    firstMem = malloc(sizeof(memStruct));
    firstMem->blocks = ListCreate();
    firstMem->nFree = 1;
    firstMem->nUsed = 0;
    firstMem->maxSize = 8192;
    firstMem->freeSpace = 8192;
    firstMem->usedSpace = 0;
    firstMem->nOps = 0;


    /* Create initial block of memory */
    init = malloc(sizeof(memBlock));
    init->isFree = true;
    init->startAddr = 0;
    init->size = TOTAL_MEM;

    ListPrepend(firstMem->blocks, init);

    return EXIT_SUCCESS;
}

memBlock* MyMalloc(int alg, int size) {
    memBlock* block;
    block = NULL;
    while (block == NULL) {
        if (alg == 0) { /* best fit */
            block = bestFit(size);
        }
        else { /* first fit */
            block = firstFit(size);
        }
        if (block == NULL) {
            RttMonWait(MEM_AVAIL);
        }
    }
    return block;
}

memBlock* bestFit(int sz) {
    memBlock* iter;
    memBlock* best;

    best = NULL;
    ListFirst(bestMem->blocks);
    do {
        iter = ListCurr(bestMem->blocks);
        /* if a free block is big enough */
        if (iter->isFree == true &&
            iter->size > sz) {
            /* if this block is the best one we've found so far */
            if (best == NULL ||
                best->size > iter->size) {
                best = iter;
            }
        }
    } while (ListNext(bestMem->blocks) != NULL);
    
    return best;
}

memBlock* firstFit(int sz) {
    memBlock* iter;

    ListFirst(firstMem->blocks);
    do {
        iter = ListCurr(firstMem->blocks);
        /* if a free block is big enough */
        if (iter->isFree == true &&
            iter->size > sz) {
            return iter;
        }
    } while (ListNext(bestMem->blocks) != NULL);
    
    return NULL;
}

int Free(int alg, int address) {
    memBlock* iterator;
    memBlock* before;
    memBlock* after;
    LIST* memory;

    RttMonEnter();

    if (alg == 0) {
        memory = bestMem->blocks;
    }
    else {
        memory = firstMem->blocks;
    }

    if (ListCount(memory) < 1) {
        fprintf(stderr, "Free: no initial memory block\n");
        exit(EXIT_FAILURE);
    }

    before = NULL;
    after = NULL;

    ListFirst(memory);
    do {
        iterator = ListCurr(memory);
        /* if the block to free has been found */
        if (iterator->startAddr == address) {
            /* set it to free */
            iterator->isFree = true;
            
            /* if the block before it is free */
            before = ListPrev(memory);
            if (before != NULL) {
                if (before->isFree == true) {
                    iterator->startAddr = before->startAddr;
                    iterator->size += before->size;
                    ListRemove(memory);
                    free(before);
                }
                else {
                    ListNext(memory);
                }
            }

            /* if the block after it is free */
            after = ListNext(memory);
            if (after != NULL) {
                if (after == iterator) {
                    after = ListNext(memory);
                }
                if (after->isFree == true) {
                    iterator->size += after->size;
                    ListRemove(memory);
                    free(after);
                }
            }

            RttMonSignal(MEM_AVAIL);
            
            RttMonLeave();

            return EXIT_SUCCESS;
        }

    } while (ListNext(memory) != NULL);

    RttMonLeave();

    return EXIT_FAILURE;
}

/* memPrinter -- show the current state of the memory block */
void memPrinter(int alg) {
    memBlock* iterator;
    LIST* memory;

    if (alg == 0) {
        memory = bestMem->blocks;
    }
    else {
        memory = firstMem->blocks;
    }
 
    if (ListCount(memory) < 1) {
        fprintf(stderr, "no initial memory block\n");
        exit(EXIT_FAILURE);
    }

    ListFirst(memory);
    do {
        iterator = ListCurr(memory);
        if (iterator->isFree == true) {
            printf("Address: %d -- Size: %d -- FREE\n",
                   iterator->startAddr, iterator->size);
        }
        else {
            printf("Address: %d -- Size: %d -- ALLOCATED\n",
                   iterator->startAddr, iterator->size);
        }
    } while (ListNext(memory) != NULL);
}
