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
#include <random.h>
#include <defs.h>

/* Total memory for this simulation will be 8 gbs (8,589,934,592 or
 * 2^33 bytes), but since the minimum allocation will be 1 mb (1,048,576
 * or 2^20 bytes), we will reduce the scale by dividing the total memory
 * by the size of the smallest possible allocation: 2^33/2^20 = 2^13 or
 * 8192 and we will use that to represent our total memory size. So 1
 * will represent 1 mb, 2 = 2 mb, and so on. */

#define TOTAL_MEM 8192
#define CONDS 1 /* number of conditions variables */
#define FFMemAvail 0

static memStruct* tMem;

int memInit() {
    memBlock* init;

    /* init monitor */
    RttMonInit(CONDS);

    /* init memory structure */
    tMem = malloc(sizeof(memStruct));
    tMem->blocks = ListCreate();
    tMem->nFree = 1;
    tMem->nUsed = 0;
    tMem->maxSize = TOTAL_MEM;
    tMem->freeSpace = TOTAL_MEM;
    tMem->usedSpace = 0;
    tMem->nOps = 0;


    /* Create initial block of memory */
    init = malloc(sizeof(memBlock));
    init->isFree = true;
    init->startAddr = 0;
    init->size = TOTAL_MEM;

    ListPrepend(tMem->blocks, init);
    return EXIT_SUCCESS;
}

memBlock* MyMalloc(int alg, int size) {
    memBlock* block;
    block = NULL;
    while (block == NULL) {
        if (alg == 0) {
            block = bestFit(size);
        }
        else {
            block = firstFit(size);
        }
        if (block == NULL) {
            printf("going to sleep...\n");
            memPrinter();
            RttMonWait(FFMemAvail);
        }
    }
    tMem->nUsed++;
    tMem->freeSpace -= size;
    tMem->usedSpace += size;
    tMem->nOps += 1;

    return block;
}

memBlock* bestFit(int sz) {
    LIST* mem;
    memBlock* iter;
    memBlock* best;
    memBlock* new;

    RttMonEnter();
    mem = tMem->blocks;

    best = NULL;
    iter = ListFirst(mem);
    while (iter != NULL) {
        /* if a free block is big enough */
        if (iter->isFree == true &&
            iter->size > sz) {
            /* if this block is the best one we've found so far */
            if (best == NULL ||
                best->size > iter->size) {
                best = iter;
            }
        }
        iter = ListNext(mem);
    }
    if (best != NULL) {
        /* create a new block */
        new = malloc(sizeof(memBlock));
        new->isFree = false;
        /* subtract its size from the old block */
        new->size = sz;
        best->size -= sz;

        /* find the old blocks spot in the list */
        iter = ListFirst(mem);
        while (iter->startAddr != best->startAddr) {
            iter = ListNext(mem);
            /*iter = ListCurr(mem);*/
        }
        new->startAddr = best->startAddr;
        best->startAddr += sz;

        ListInsert(mem, new);

        RttMonLeave();
        return new;
    }
    else {
        RttMonLeave();
        return best;
    }
}

memBlock* firstFit(int sz) {
    LIST* mem;
    memBlock* iter;
    memBlock* found;
    memBlock* new;

    RttMonEnter();
    mem = tMem->blocks;

    found = NULL;
    iter = ListFirst(mem);
    while (iter != NULL) {
        iter = ListCurr(mem);
        /* if a free block is big enough */
        if (iter->isFree == true &&
            iter->size > sz) {
            found = iter;
            break;
        }
        iter = ListNext(mem);
    }
    
    if (found != NULL) {
        /* create a new block */
        new = malloc(sizeof(memBlock));
        new->isFree = false;
        /* subtract its size from the old block */
        new->size = sz;
        iter->size -= sz;

        new->startAddr = iter->startAddr;
        iter->startAddr += sz;

        ListInsert(mem, new);

        RttMonLeave();

        return new;
    }
    else {
        RttMonLeave();
        return found;
    }
}

int MyFree(int address) {
    memBlock* iterator;
    memBlock* before;
    memBlock* after;
    LIST* mem;
    bool bef, aft;

    RttMonEnter();

    mem = tMem->blocks;

    if (ListCount(mem) < 1) {
        fprintf(stderr, "Free: no initial memory block\n");
        exit(EXIT_FAILURE);
    }
    if (ListCount(mem) < 2) {
        fprintf(stderr, "Free: cannot free initial memory block\n");
        exit(EXIT_FAILURE);
    }

    tMem->nOps += 1;

    before = NULL;
    after = NULL;

    iterator = ListFirst(mem);
    while (iterator != NULL) {
        bef = false;
        aft = false;

        iterator = ListCurr(mem);
        /* if the block to free has been found */
        if (iterator->startAddr == address) {
            /* set it to free */
            iterator->isFree = true;
            
            /* update stats */
            tMem->nUsed -= 1;
            tMem->freeSpace += iterator->size;
            tMem->usedSpace -= iterator->size;
            
            /* if the block before it is free */
            before = ListPrev(mem);
            if (before != NULL) {
                if (before->isFree == true) {
                    bef = true;
                    iterator->startAddr = before->startAddr;
                    iterator->size += before->size;
                    ListRemove(mem);
                    free(before);
                }
                else {
                    ListNext(mem);
                }
            }
            /* if the block after it is free */
            after = ListNext(mem);
            if (after != NULL) {
                if (after == iterator) {
                    after = ListNext(mem);
                }
                if (after->isFree == true) {
                    aft = true;
                    iterator->size += after->size;
                    ListRemove(mem);
                    free(after);
                }
            }
            /* update # of free blocks */
            if (bef == true && aft == true) {
                tMem->nFree -= 1;
            }
            else if (bef == false && aft == false) {
                tMem->nFree += 1;
            }

            RttMonSignal(FFMemAvail);
            
            RttMonLeave();
            return EXIT_SUCCESS;
        }
        iterator = ListNext(mem);
    }
    RttMonLeave();
    return EXIT_FAILURE;
}

int unblock() {
    RttMonSignal(0);
    return 0;
}

/* memPrinter -- show the current state of the memory block */
void memPrinter() {
    /*memBlock* iter;*/
    LIST* mem;

    RttMonEnter();
    mem = tMem->blocks;
 
    if (ListCount(mem) < 1) {
        fprintf(stderr, "no initial memory block\n");
        exit(EXIT_FAILURE);
    }

    /*iter = ListFirst(mem);
    while (iter != NULL) {
        iterator = ListCurr(mem);
        if (iterator->isFree == true) {
            printf("Address: %d -- Size: %d -- FREE\n",
                   iterator->startAddr, iterator->size);
        }
        else {
            printf("Address: %d -- Size: %d -- ALLOCATED\n",
                   iterator->startAddr, iterator->size);
        }
        iter = ListNext(mem);
    }*/

    /*printf("Free blocks: %d\n", tMem->nFree);
    printf("Used blocks: %d\n", tMem->nUsed);
    printf("Total Size: %d\n", tMem->maxSize);
    printf("Free Space: %d\n", tMem->freeSpace);
    printf("Used Space: %d\n", tMem->usedSpace);
    printf("Number of Operations: %d\n", tMem->nOps);*/
    printf("%d,%d,%d,%d,%d,"
           "%d,%d,%d,%f\n",
           tMem->nOps, tMem->nFree, tMem->freeSpace, tMem->nUsed,
           tMem->usedSpace, tMem-> maxSize, MN_ALLOC, STDDEV_ALLOC, FREEPROB);

    RttMonLeave();
}

void* MyMemStats(int alg, int stat, void* statCont) {
    LIST* mem;
    memStat* cont;

    RttMonEnter();
    mem = tMem->blocks;
    if (ListCount(mem) < 1) {
        fprintf(stderr, "no initial memory block\n");
        exit(EXIT_FAILURE);
    }
    if (alg == 0) {
        printf("Best fit algorithm\n");
    }
    else {
        printf("First fit algorithm\n");
    }
    if (stat == 1) {
        printf("All Stats:\n");
    }

    cont = (memStat*)statCont;
    cont->nFree = tMem->nFree;
    printf("Free blocks: %d\n", tMem->nFree);
    cont->nUsed = tMem->nUsed;
    printf("Used blocks: %d\n", tMem->nUsed);
    printf("Total Size: %d\n", tMem->maxSize);
    cont->freeSpace = tMem->freeSpace;
    printf("Free Space: %d\n", tMem->freeSpace);
    cont->usedSpace = tMem->usedSpace;
    printf("Used Space: %d\n", tMem->usedSpace);
    cont->nOps = tMem->nOps;
    printf("Number of Operations: %d\n", tMem->nOps);

    RttMonLeave();

    return cont;
}
