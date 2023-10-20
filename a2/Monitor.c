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

RttSem enterqSem; 
RttSem urgentqSem;
RttSem condqSem[10];
/*
 * Mutex can only have value 0 / 1
*/
RttSem mutex;

RttThreadId *waiting;
int occupied;


int MonEnter () {
    printf("MonEnter() reached\n");
    /* if monitor is occupied add to entering queue */
    if (occupied) {
        ListPrepend(enterq, waiting);
        RttP(enterqSem);
    }
    /* else set monitor to be occupied */
    else {
        occupied = 1;
        RttP(mutex);
    }
     
    return 0;
}


int MonLeave () {
    printf("MonLeave() reached\n");
    /* allow current thread to leave, before actually call another thread */

    /* if urgentq not empty, take item off */
    if (ListCount(urgentq) > 0) {
        waiting = (RttThreadId*)ListTrim(urgentq);
        RttV(urgentqSem);
    }
    /* else if enterq not empty, take item off */
    else if (ListCount(enterq) > 0){
        waiting = (RttThreadId*)ListTrim(enterq);
        RttV(enterqSem);
    }
    /* else set occupied to false */
    else {
        occupied = 0;
        RttV(mutex);
    }
    return 0;
}


int  MonWait (int CV) {
    if (CV < 0) return -1;
    printf("MonWait() reached, %d\n", CV);

    /* add to cv_waiting list */
    ListPrepend(condq[CV], waiting);
    RttP(condqSem[CV]);
 
    /* if urgentq not empty, take item off */
    if (ListCount(urgentq) > 0) {
        waiting = (RttThreadId*)ListTrim(urgentq);
        RttV(urgentqSem);
    }
    /* if enterq not empty, take item off */   
    else if (ListCount(enterq) > 0) {
        waiting = (RttThreadId*)ListTrim(enterq);
        RttV(enterqSem);
    }
    /* else set occupied to false */
    else {
        occupied = 0;
        RttV(mutex);
    }
    return 0;
}


int  MonSignal (int CV) {
    if (CV < 0) return -1;
    printf("MonSignal() reached, %d\n", CV);
    /* if there is a non-empty cv list */
    if (ListCount(condq[CV]) > 0) {
        /* take first item off the CV_waiting list
         * and unlock the current CV_waiting list 
        */
        waiting = (RttThreadId*)ListTrim(condq[CV]);
        RttV(condqSem[CV]);

        /* add current thread to the urgentq */
        ListPrepend(urgentq, waiting);
        RttP(urgentqSem);
    }
    else {
        printf("There is no thread waiting on condition: %d\n", CV);
    }
    return 0; 
}
 
int MonInit (int numConds) {
    LIST *newQueue;
    int index;
    int count;
    RttThreadId threads[100];
    RttThreadId returnVal;
    if (numConds < 1) return -1;
    printf("MonInit() reached, %d\n", numConds);
    for (count = 0; count < numConds; count++) {
        newQueue = ListCreate();
        condq[count] = newQueue;
        RttNewSem(&(condqSem[count]), 0);
    }
    enterq = ListCreate();
    urgentq = ListCreate(); 
    RttNewSem(&enterqSem, 1);
    RttNewSem(&urgentqSem, 1);
    RttNewSem(&mutex, 1);
    
    for (;;) {
        MonEnter();
        returnVal = threads[index];
        waiting = &returnVal;
        /* Incoming thread will keep calling MonEnter() */
        MonLeave();
        if (index == 99) {
            index = 0;  
        }
        else {
            index++;
        }
    }
    return 0;
}
