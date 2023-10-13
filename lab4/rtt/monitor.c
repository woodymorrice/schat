/* CMPT332 - Group 14
 * Phong Thanh Nguyen (David) - wdz468 - 11310824
 * Woody Morrice - wam553 - 11071060 */

#include <stdio.h>

#include <rtthreads.h>
#include <RttCommon.h>

#include <list.h>

LIST *conQueue[10];

LIST *enterq;
LIST *urgentq;

static RttThreadId server;
const int STKSIZE = 65536;

const int ENTER = 0;
const int LEAVE = 1;
const int WAIT = 2;
const int SIGNAL = 3;
const int SREPLY = 4;

static unsigned int size = 4;
static int reply;
static int conds;
static int currentCV;

/* RttMonServer -- server PROCESS that handles
 * the coordination by putting processes on lists
 * according to the semantics of Monitors */
RTTTHREAD MonServer() {
    int occupied;
    RttThreadId sender;
    int messageType;
    RttThreadId *waiting;

    occupied = 0;

    for (;;) {
        if (0 !=
        RttReceive(&sender, &messageType, &size)) {
            fprintf(stderr, "Error receiving message\n");
        }

        switch (messageType) {
            case 0: /* ENTER */
                printf("ENTER received\n");

                /* if monitor is occupied add to entering queue */
                if (occupied) {
                    ListPrepend(enterq, &sender);
                    printf("%d items in enterq\n", ListCount(enterq));
                }
                /* else set monitor to occupied and reply to sender */
                else {
                    occupied = 1;
                    RttReply(sender, (void*)&SREPLY,
                             size);
                }
                break;

            case 1: /* LEAVE */
                printf("LEAVE received\n");

                /* if urgentq not empty, take item off urgentq, reply */
                if (ListCount(urgentq) > 0) {
                    waiting = (RttThreadId*)ListTrim(urgentq);
                    RttReply(*waiting, (void*)&SREPLY,
                             size);
                }
                /* else if enterq not empty, take item off enterq, reply */
                else if (ListCount(enterq) > 0) {
                    waiting = (RttThreadId*)ListTrim(enterq);
                    RttReply(*waiting, (void*)&SREPLY,
                             size);
                }
                /* else monBusy to false, reply to thread executing leave */
                else {
                    occupied = 0;
                    RttReply(sender, (void*)&SREPLY,
                             size);
                }
                break;

            case 2: /* WAIT */
                printf("WAIT received\n");

                /* add to cv_waitinglist */
                ListPrepend(conQueue[currentCV], &sender);
                printf("%d items in conQueue[%d]\n",
                        ListCount(conQueue[currentCV]), currentCV);

                /* if urgentq not empty, take item off urgentq, reply */
                if (ListCount(urgentq) > 0) {
                    waiting = (RttThreadId*)ListTrim(urgentq);
                    RttReply(*waiting, (void*)&SREPLY,
                             size);
                }
                /* else if enterq not empty, take item off enterq, reply */
                else if (ListCount(enterq) > 0) {
                    waiting = (RttThreadId*)ListTrim(enterq);
                    RttReply(*waiting, (void*)&SREPLY,
                             size);
                }
                /* else set monBusy to false */
                else {
                    occupied = 0;
                }
                break;

            case 3: /* SIGNAL */
                printf("SIGNAL received\n");

                /* if there is non-empty cvlist */
                if (ListCount(conQueue[currentCV]) > 0) {
                    /* take first item off the CV_waitinglist, reply */
                    waiting = 
                        (RttThreadId*)ListTrim(conQueue[currentCV]);
                    RttReply(*waiting, (void*)&SREPLY,
                             size);
                    /* add current thread to the urgentq */
                    ListPrepend(urgentq, &sender);
                    printf("%d items in urgentq\n", ListCount(urgentq));
                }
                break;

            default:
                /* else reply to signaller */
                RttReply(sender, (void*)&SREPLY,
                         size);
                break;
        }
    }
}

/* RttMonInit -- initializes the monitor with the 
 * specified number of condition variables */
int RttMonInit(int numConds) {
    LIST *newConds;
    int cond;

    RttSchAttr attr;
    attr.startingtime = RTTZEROTIME;
    attr.priority = RTTNORM;
    attr.deadline = RTTNODEADLINE;   
    
    conds = numConds;

    for (cond = 0; cond < numConds; cond ++) {
        newConds = ListCreate();
        conQueue[cond] = newConds;
    }
    
    enterq = ListCreate();
    urgentq = ListCreate();
    
    RttCreate(&server, MonServer, STKSIZE,
              "Server", NULL, attr, RTTUSR);
    
    return 0;
}

/* RttMonEnter -- signals to the server that
 * a process wishes to enter the monitor */
int RttMonEnter() {
    RttSend(server, (void*)&ENTER, size, 
            &reply, &size);
    return 0;
}

/* RttMonLeave -- signals to the server that
 * a process wishes to leave the monitor */
int RttMonLeave() {
    RttSend(server, (void*)&LEAVE, size, 
            &reply, &size); 
    return 0;  
}

/* RttMonWait -- causes the calling process to
 * wait on some condition variable (CV) */
int RttMonWait(int CV) {
    currentCV = CV;
    RttSend(server, (void*)&WAIT, size, 
            &reply, &size);    
    return 0;
}

/* RttMonSignal -- signals the process at
 * the head of the CV queue to resume */
int RttMonSignal(int CV) { 
    currentCV = CV;
    RttSend(server, (void*)&SIGNAL, size,
            &reply, &size);
    return 0;
}

