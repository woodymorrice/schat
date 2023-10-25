/* CMPT332 - Group 14
 * Phong Thanh Nguyen (David) - wdz468 - 11310824
 * Woody Morrice - wam553 - 11071060 */

/* List Library provided with consent by
 * Joseph Medernach, imy309, 11313955
 * John Miller, knp254, 11323966 */


#include <rtthreads.h>
#include <stdio.h>
#include <RttCommon.h>
#include <list.h>
 
LIST *enterq;
LIST *urgentq;
LIST *condq[10];

RttSem enterqSem; 
RttSem urgentqSem;
RttSem condqSem[10];
/*
 * Mutex can only have value 0 / 1
*/
RttSem mutex;
int occupied;


int MonEnter () {
    /* if monitor is occupied add to entering queue */
    RttThreadId waiting;
    waiting = RttMyThreadId();
    if (occupied == 0) {
        ListPrepend(enterq, &waiting);
        /*printf("Enter: %d items in enterq\n", ListCount(enterq));*/
        RttP(enterqSem);
    }
    else {
        RttP(mutex);
        occupied = 1;
    }
    /*printf("Reach here!\n");*/
    return 0;
}


int MonLeave () {
    /* allow current thread to leave, before actually call another thread */

    /* if urgentq not empty, take item off */
    if (ListCount(urgentq) > 0) {
        ListTrim(urgentq);
        /*printf("Leave: %d items in urgentq\n", ListCount(urgentq));*/
        RttV(urgentqSem);
    }
    /* else if enterq not empty, take item off */
    else if (ListCount(enterq) > 0){
        ListTrim(enterq);
        /*printf("Leave: %d itesms in enterq\n", ListCount(enterq));*/
        RttV(enterqSem);
    }
    else {
    /* releasing the lock */
        occupied = 0;
        RttV(mutex);
    }
    return 0;
}


int  MonWait (int CV) {
    RttThreadId waiting;
    waiting = RttMyThreadId();
    if (CV < 0) return -1;

    /* add to cv_waiting list */
    ListPrepend(condq[CV], &waiting);
    printf("Prepend: %d items in the condq[%d]\n", ListCount(condq[CV]), CV);
 
    /* if urgentq not empty, take item off */
    if (ListCount(urgentq) > 0) {
        ListTrim(urgentq);
        printf("Wait: %d items in urgentq\n", ListCount(urgentq));
        RttV(urgentqSem);
    }
    /* if enterq not empty, take item off */   
    else if (ListCount(enterq) > 0) {
        ListTrim(enterq);
        printf("Wait: %d items in enterq\n", ListCount(enterq));
        RttV(enterqSem);
    }
    else {
        occupied = 0; 
        RttV(mutex);
    }
    RttP(condqSem[CV]);
    return 0;
}


int  MonSignal (int CV) {
    RttThreadId waiting;  
    waiting = RttMyThreadId();
    if (CV < 0) return -1;
    /* if there is a non-empty cv list */
    if (ListCount(condq[CV]) > 0) {
        /* take first item off the CV_waiting list
         * and unlock the current CV_waiting list 
        */
        ListTrim(condq[CV]);
        /*printf("Signal: %d items in condq[%d]\n", ListCount(condq[CV]), CV);*/
        RttV(condqSem[CV]);

        /* add current thread to the urgentq*/ 
        ListPrepend(urgentq, &waiting);
        /*printf("Signal: %d items in urgentq\n", ListCount(urgentq));*/
        RttP(urgentqSem);
    }
    else {
        printf("No thread waiting on condq[%d]\n", CV);
    }
    return 0; 
}
 
int MonInit (int numConds) {
    LIST *newQueue;
    int count;
    if (numConds < 1) return -1;
    for (count = 0; count < numConds; count++) {
        newQueue = ListCreate();
        condq[count] = newQueue;
        RttNewSem(&(condqSem[count]), 0);
    }
    enterq = ListCreate();
    urgentq = ListCreate(); 
    RttNewSem(&enterqSem, 1);
    RttNewSem(&urgentqSem, 0);
    RttNewSem(&mutex, 1);
    return 0;
}
