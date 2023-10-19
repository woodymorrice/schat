/* CMPT332 - Group 14
 * Phong Thanh Nguyen (David) - wdz468 - 11310824
 * Woody Morrice - wam553 - 11071060 */

#include <unistd.h>
#include <fcntl.h>
#include <stdio.h>
#include <string.h>

#include <standards.h>
#include <os.h>

#include <list.h>

const int MAX_LEN = 255;
const int STD_MSG = 0;
const int STD_RPLY = 0;

void sServer();
void sGetInput();
void sSendData();
void sGetData();
void sDisplayData();

static PID sServerPID;
static PID sGetInputPID;
static PID sSendDataPID;
static PID sGetDataPID;
static PID sDisplayDataPID;

int mainp() {
    if (PNUL == (sServerPID = Create(sServer, 65536,
       "sServer", NULL, NORM, USR))) {
        printf("Error creating sServer thread\n");
    }
    if (PNUL == (sGetInputPID = Create(sGetInput, 65536,
       "sGetInput", NULL, NORM, USR))) {
        printf("Error creating sGetInput thread\n");
    }
    if (PNUL == (sSendDataPID = Create(sSendData, 65536,
       "sSendData", NULL, NORM, USR))) {
        printf("Error creating sSendData thread\n");
    }
    if (PNUL == (sGetDataPID = Create(sGetData, 65536,
       "sGetData", NULL, NORM, USR))) {
        printf("Error creating sGetData thread\n"); 
    }
    if (PNUL == (sDisplayDataPID = Create(sDisplayData, 65536,
       "sDisplayData", NULL, NORM, USR))) {
        printf("Error creating sDisplayData thread\n");
    }
    return 0;
}


/* sGetInput -- waits on input from the keyboard,
 * takes input and packages it into a message to
 * send to the server upon newline */
void sGetInput() {
    char buf[256];
    int msgLen;

    fcntl(0, F_SETFL, fcntl(0, F_GETFL) | O_NONBLOCK);

    for (;;) {
        msgLen = read(0, buf, MAX_LEN);
        if (msgLen > 0) {

            if (strncmp("exit\n", buf, msgLen) == 0 ||
                strncmp("quit\n", buf, msgLen) == 0) {
                fcntl(0, F_SETFL, fcntl(0, F_GETFL) | ~O_NONBLOCK);
                exit(0);
            }

            /* for debugging (remove later) */
            /* write(1, buf, msgLen); */

            if (*(int*)Send(sServerPID, &buf, &msgLen)
                    == NOSUCHPROC) {
                write(1, "Error in Send: invalid process ID\n", 35);
                exit(0);
            }
        }
    }

    fcntl(0, F_SETFL, fcntl(0, F_GETFL) | ~O_NONBLOCK);
}

/* sServer -- coordinates the sending of messages
 * by managing a list of messages from sGetInput()
 * and serving those messages to sSendData() */
void sServer() {
    LIST* outgoing;
    char* outArr[12];
    /* LIST* incoming;
    char* inArr[12]; */

    int msgLen;
    int index;

    outgoing = ListCreate();
    /* incoming = ListCreate(); */

    msgLen = 0; /* dummy value */
    index = 0;
    printf("sServer() thread reached\n");

    for (;;) {

        /* get input */
        outArr[index] = strndup((char*)
                Receive(&sGetInputPID, &msgLen), msgLen);
        printf("%s\n", outArr[index]);
        ListPrepend(outgoing, &outArr[index]);
        Reply(sGetInputPID, (void*)&STD_RPLY, sizeof(STD_RPLY));

        /* send data */
        /* Receive(&sSendDataPID, &msgLen);
        Reply(sSendDataPID, ListTrim(outgoing),
                sizeof(void*)); */

        /* get data */
        /* Receive(&sGetDataPID, &msgLen);
        Reply(sGetDataPID, (void*)&STD_RPLY,
                sizeof(void*)); */

        /* display data */
        /* Receive(&sDisplayDataPID, &msgLen);
        Reply(sDisplayDataPID, (void*)&STD_RPLY,
                sizeof(void*)); */


        if (index < 11) {
            index++;
        }
        else {
            index = 0;
        }
    }

}

/* sSendData -- takes data packages from the server
 * and sends them to remote UNIX processes using
 * UDP protocol */
void sSendData() {
    char* message;
    int msgLen;
    printf("sSendData() thread reached\n");

    for (;;) {
        if (*(int*)Send(sServerPID, (void*)&STD_MSG, &msgLen)
                == NOSUCHPROC) {
            write(1, "Error in Send: invalid process ID\n", 35);
            exit(0);   
        }
        message = (char*)Receive(&sServerPID, &msgLen);
        printf("%s\n", message);
    }
}

/* sGetData -- listens on the specified port for
 * UDP data packets and retrieves them */
void sGetData() {
    char* message;
    int msgLen;
    printf("sGetData() thread reached\n");

    for (;;) {
        if (*(int*)Send(sServerPID, (void*)&STD_MSG, &msgLen)
                == NOSUCHPROC) {
            write(1, "Error in Send: invalid process ID\n", 35);
            exit(0);   
        }
        message = (char*)Receive(&sServerPID, &msgLen);

    }
}

/* sDisplayData -- prints messages received from
 * the network to the local terminal */
void sDisplayData() {
    char* message;
    int msgLen;
    printf("sDisplayData() thread reached\n");
    
    for (;;) {
        if (*(int*)Send(sServerPID, (void*)&STD_MSG, &msgLen)
                == NOSUCHPROC) {
            write(1, "Error in Send: invalid process ID\n", 35);
            exit(0);   
        }
        message = (char*)Receive(&sServerPID, &msgLen);

    }
}

