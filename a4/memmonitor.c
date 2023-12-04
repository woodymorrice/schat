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

static memStruct bestMem;
static memStruct firstMem;

int bestInit() {
    memBlock* init;


}

static LIST* memory;

int BestFitInit()  {
    memBlock* init;


    RttMonInit(CONDS);
    memory = ListCreate();

    /* Create initial block of memory */
    init = malloc(sizeof(memBlock));
    init->isFree = TRUE;
    init->startAddr = 0;
    init->size = TOTAL_MEM;

    ListPrepend(memory, init);

   return SUCCESS; 
}


memBlock* BFAllocate(int size) {
    memBlock* iterator;
    memBlock* bestFit;
    memBlock* newBlock;

    RttMonEnter();

    printf("Allocating a block of size %d\n", size);

    if (ListCount(memory) < 1) {
        fprintf(stderr, "no initial memory block\n");
        exit(FAILURE);
    }

    bestFit = NULL;
    while (bestFit == NULL) {
        ListFirst(memory);
        do {
            iterator = ListCurr(memory);
            /* if a free block is big enough */
            if (iterator->isFree == TRUE &&
                iterator->size   >  size) {
                /* if this block is the best one we've found so far */
                if (bestFit == NULL ||
                    bestFit->size > iterator->size) {
                    bestFit = iterator;
                }
            }
        } while (ListNext(memory) != NULL);
        if (bestFit == NULL) {
            RttMonWait(MEM_AVAIL);
        }
    }
    
    /* create a new block */
    newBlock = malloc(sizeof(memBlock));
    newBlock->isFree = FALSE;
    /* subtract its size from the old block */
    newBlock->size = size;
    bestFit->size -= size;
        
    /* find the old blocks spot in the list */
    iterator = ListFirst(memory);
    while (iterator->startAddr != bestFit->startAddr) {
        ListNext(memory);
        iterator = ListCurr(memory);
    }

    /* place new block  at the old blocks start address */
    newBlock->startAddr = bestFit->startAddr;
    /* new start address for old block is right after
    * the new block ends */
    bestFit->startAddr += size;
      
    /* insert the new block just before the old block */
    ListInsert(memory, newBlock);

    memPrinter();

    RttMonLeave();

    return newBlock;
}


int Free(int address) {
    memBlock* iterator;
    memBlock* before;
    memBlock* after;

    RttMonEnter();

    printf("Freeing address %d\n", address);    

    if (ListCount(memory) < 1) {
        fprintf(stderr, "no initial memory block\n");
        exit(FAILURE);
    }

    before = NULL;
    after = NULL;

    ListFirst(memory);
    do {
        iterator = ListCurr(memory);
        /* if the block to free has been found */
        if (iterator->startAddr == address) {
            /* set it to free */
            iterator->isFree = TRUE;
            
            /* if the block before it is free */
            before = ListPrev(memory);
            if (before != NULL) {
                if (before->isFree == TRUE) {
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
                if (after->isFree == TRUE) {
                    iterator->size += after->size;
                    ListRemove(memory);
                    free(after);
                }
            }

            memPrinter();

            RttMonSignal(MEM_AVAIL);
            
            RttMonLeave();

            return SUCCESS;
        }

    } while (ListNext(memory) != NULL);

    RttMonLeave();

    return FAILURE;
}

/* memPrinter -- show the current state of the memory block */
void memPrinter() {
    memBlock* iterator;
 
    if (ListCount(memory) < 1) {
        fprintf(stderr, "no initial memory block\n");
        exit(FAILURE);
    }

    ListFirst(memory);
    do {
        iterator = ListCurr(memory);
        if (iterator->isFree == TRUE) {
            printf("Address: %d -- Size: %d -- FREE\n",
                   iterator->startAddr, iterator->size);
        }
        else {
            printf("Address: %d -- Size: %d -- ALLOCATED\n",
                   iterator->startAddr, iterator->size);
        }
    } while (ListNext(memory) != NULL);
}
