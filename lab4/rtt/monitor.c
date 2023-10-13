/* CMPT332 - Group 14
 * Phong Thanh Nguyen (David) - wdz468 - 11310824
 * Woody Morrice - wam553 - 11071060 */

#include <stdio.h>

#include <rtthreads.h>
#include <RttCommon.h>

#include <list.h>

LIST *enterq;
LIST *urgentq;
LIST *conQueue[10];

const int STKSIZE = 65536;
const int ENTER = 20;
const int LEAVE = 21;
/* const int WAIT = 22;
const int SIGNAL = 23; */
const int SREPLY = 24;

static RttThreadId server;
static unsigned int size = 4;
static int reply;
static int conds;
/* static int currentCV; */

/* RttMonServer -- server PROCESS that handles
 * the coordination by putting processes on lists
 * according to the semantics of Monitors */
RTTTHREAD MonServer() {
    int occupied;
    /* RttThreadId sender; */
    int messageType;
    RttThreadId *waiting;

    RttThreadId sendArr[100];
    int index;

    index = 0;
    occupied = 0;

    for (;;) {
        if (0 !=
        RttReceive(&sendArr[index], &messageType, &size)) {
            fprintf(stderr, "Error receiving message\n");
        }

        switch (messageType) {
            case 0:
            case 1:
            case 2:
            case 3:
            case 4:
            case 5:
            case 6:
            case 7:
            case 8:
            case 9: /* WAIT */
                /* printf("WAIT received\n"); */
                if (messageType > conds - 1) {
                    fprintf(stderr, "Error: CV does not exist\n");
                }

                /* add to cv_waitinglist */
                ListPrepend(conQueue[messageType], &sendArr[index]);
                /* printf("%d items in conQueue[%d]\n",
                        ListCount(conQueue[messageType]), messageType); */

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

            case 10:
            case 11:
            case 12:
            case 13:
            case 14:
            case 15:
            case 16:
            case 17:
            case 18:
            case 19:
                /* printf("SIGNAL received\n"); */
                messageType -= 10;
                if (messageType > conds - 1) {
                    fprintf(stderr, "Error: CV does not exist\n");
                }

                /* if there is non-empty cvlist */
                if (ListCount(conQueue[messageType]) > 0) {
                    /* take first item off the CV_waitinglist, reply */
                    waiting = 
                        (RttThreadId*)ListTrim(conQueue[messageType]);
                    RttReply(*waiting, (void*)&SREPLY,
                             size);
                    /* add current thread to the urgentq */
                    ListPrepend(urgentq, &sendArr[index]);
                    /* printf("%d items in urgentq\n", ListCount(urgentq)); */
                } 
                /* else reply to signaller */
                else {
                    RttReply(sendArr[index], (void*)&SREPLY,
                             size);
                }
                break;

            case 20: /* ENTER */
                /* printf("ENTER received\n"); */

                /* if monitor is occupied add to entering queue */
                if (occupied) {
                    ListPrepend(enterq, &sendArr[index]);
                    printf("%d items in enterq\n", ListCount(enterq));
                }
                /* else set monitor to occupied and reply to sender */
                else {
                    occupied = 1;
                    RttReply(sendArr[index], (void*)&SREPLY,
                             size);
                }
                break;

            case 21: /* LEAVE */
                /* printf("LEAVE received\n"); */
                RttReply(sendArr[index], (void*)&SREPLY,
                         size);

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
                }    
                break;

            default:
                /* no other messages should be sent */
                break;
        }
        if (index == 99) {
            index = 0;
        }
        else {
            index++;
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
    RttSend(server, (void*)&CV, size, 
            &reply, &size);    
    return 0;
}

/* RttMonSignal -- signals the process at
 * the head of the CV queue to resume */
int RttMonSignal(int CV) {
    CV += 10;
    RttSend(server, (void*)&CV, size,
            &reply, &size);
    return 0;
}

