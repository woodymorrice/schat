/* CMPT332 - Group 14
 * Phong Thanh Nguyen (David) - wdz468 - 11310824
 * Woody Morrice - wam553 - 11071060 */
#ifndef BESTFITMONITOR
#define BESTFITMONITOR

typedef struct memBlock {
    int isFree;
    int startAddr;
    int size;
} memBlock;

int BestFitInit();
struct memBlock* BFAllocate(int);
int Free(int);
void memPrinter();

#endif
