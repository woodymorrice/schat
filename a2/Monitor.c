/* CMPT332 - Group 14
 * Phong Thanh Nguyen (David) - wdz468 - 11310824
 * Woody Morrice - wam553 - 11071060 */


#include <rtthreads.h>
#include <stdio.h>
#include <RttCommon.h>
#include <list.h>
 
LIST enterq;
LIST condq;
LIST urgentq;
RttSem mutex; 
 
int MonInit (int numConds) {
    if (numConds < 1) {
        return -1;
    }
    RttSem() 
    return 0;
}

int MonEnter () {
    return 0;
}


int MonLeave () {
    return 0;
}


void  MonWait (int CV) {
    printf("MonWait() reached, %d\n", CV);
}


void  MonSignal (int CV) {
   printf("MonSignal() reached, %d\n", CV); 
}
