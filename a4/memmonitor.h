/* CMPT332 - Group 14
 * Phong Thanh Nguyen (David) - wdz468 - 11310824
 * Woody Morrice - wam553 - 11071060 */
#ifndef MEMMONITOR
#define MEMFITMONITOR

typedef struct memStruct {
    LIST *blocks;
    int nFree;
    int nUsed;

    int maxSize;
    int freeSpace;
    int usedSpace;

    int nOps;
} memStruct;

typedef struct memBlock {
    int isFree;
    int startAddr;
    int size;
} memBlock;


int bestInit();
int firstInit();
struct memBlock* MyMalloc(int, int);
struct memBlock* bestFit(int);
struct memBlock* firstFit(int);
int Free(int, int);
void memPrinter(int);

#endif
