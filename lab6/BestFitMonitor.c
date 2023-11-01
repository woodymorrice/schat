/* CMPT332 - Group 14
 * Phong Thanh Nguyen (David) - wdz468 - 11310824
 * Woody Morrice - wam553 - 11071060 */

#include <stdio.h>
#include <stdlib.h>

#include <monitor.h>
#include <list.h>
#include <BestFitMonitor.h>

#define TRUE 1
#define FALSE 0
#define TOTAL_MEM 32768
#define SUCCESS 0
#define FAILURE 1
#define CONDS 1 /* number of conditions variables */

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
            RttMonWait(0);
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

    /* place it at the old blocks start address */
    newBlock->startAddr = bestFit->startAddr;
    /* new start address for old block is right after
    * the new block ends */
    bestFit->startAddr += size;
      
    /* insert the new block just before the old block */
    ListInsert(memory, newBlock);

    RttMonLeave();
    return newBlock;
}


int Free(int address) {
    memBlock* iterator;
    memBlock* before;
    memBlock* after;
    
    RttMonEnter();

    if (ListCount(memory) < 1) {
        fprintf(stderr, "no initial memory block\n");
        exit(FAILURE);
    }

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
            }

            /* if the block after it is free */
            after = ListNext(memory);
            if (after != NULL) {
                if (after->isFree == TRUE) {
                    iterator->size += after->size;
                    ListRemove(memory);
                    free(after);
                }
            }
            RttMonSignal(0);
            RttMonLeave();
            return SUCCESS;
        }

    } while (ListNext(memory) != NULL);

    return FAILURE;
}

void memPrinter() {
    memBlock* iterator;
 
    if (ListCount(memory) < 1) {
        fprintf(stderr, "no initial memory block\n");
        exit(FAILURE);
    }
    
    printf("Total size: %d\n", TOTAL_MEM); 

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
