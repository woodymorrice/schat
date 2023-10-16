/* CMPT332 - Group 14
 * Phong Thanh Nguyen (David) - wdz468 - 11310824
 * Woody Morrice - wam553 - 11071060 */


#include <rtthreads.h>
#include <stdio.h>
#include <RttCommon.h>
#include <list.h>
 
LIST *enterq;
LIST *urgentq;
LIST *condq[10];
RttSem *enterqSem; 
RttSem *urgentqSem;
RttSem *condqSem[10];
RttSem *mutex;
 
int MonInit (int numConds) {
    LIST *newQueue;
    int index;
    if (numConds < 1) return -1;
    printf("MonInit() reached, %d\n", numConds);
    for (index = 0; index < numConds; index++) {
        newQueue = ListCreate();
        condq[index] = newQueue;
        RttNewSem(condqSem[index], 0);
    }
    enterq = ListCreate();
    urgentq = ListCreate(); 
    RttNewSem(enterqSem, 0);
    RttNewSem(urgentqSem, 0);
    RttNewSem(mutex, 0);
    return 0;
}

int MonEnter () {
    printf("MonEnter() reached\n"); 
    return 0;
}


int MonLeave () {
    printf("MonLeave() reached\n");
    return 0;
}


int  MonWait (int CV) {
    if (CV < 0) return -1;
    printf("MonWait() reached, %d\n", CV);
    return 0;
}


int  MonSignal (int CV) {
    if (CV < 0) return -1;
    printf("MonSignal() reached, %d\n", CV);
    return 0; 
}
