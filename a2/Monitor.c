/* CMPT332 - Group 14
 * Phong Thanh Nguyen (David) - wdz468 - 11310824
 * Woody Morrice - wam553 - 11071060 */


#include <rtthreads.h>
#include <stdio.h>
#include <RttCommon.h>
#include <list.h>
 
 
int MonInit (int numConds) {
    if (numConds < 1) return -1;
    printf("MonInit() reached, %d\n", numConds);
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
