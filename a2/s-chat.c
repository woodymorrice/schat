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

static int   hostPort;
static char* destName[5];
static int   destPort[5];


int mainp(int argc, char* argv[]) {
    int i;
    int j;

    if (argc < 4 || argc > 12) {
        printf("s-chat usage: s-chat localport " 
               "destname destport dest2name dest2port...\n");
        exit(-1);
    }
    else {
        hostPort = atoi(argv[1]);
        for (i=2; i < argc; i++) {
            j = 0;
            destName[j] = argv[i];
            i++;
            destPort[j] = atoi(argv[i]);
            j++;
        }
    }

    if (PNUL == (sServerPID = Create(sServer, 65536,
       "sServer", NULL, HIGH, USR))) {
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
    int msgLength;
    int *reply;
    char* message;

    message = "test successful";
    msgLength = strlen(message);

    for (;;) {
        reply = (int*)Send(sServerPID, (void*)message, &msgLength);
        if (*reply == NOSUCHPROC) {
            printf("GetInput send failed\n");
        }
        else {
            printf("GetInput received reply '%d'\n", *reply);
        }
    }

}

/* sServer -- coordinates the sending of messages
 * by managing a list of messages from sGetInput()
 * and serving those messages to sSendData() */
void sServer() {
    PID sender;
    int msgLength;
    LIST* outgoing;
    LIST* incoming;

    /* received messages */
    void* received;
    char* message;
    int* stdMsg;

    char* reply;

    reply = "goodbye";

    outgoing = ListCreate();
    incoming = ListCreate();

    for (;;) {
        received = Receive(&sender, &msgLength);
        
        if (sender == sGetInputPID) {
            message = (char*) received;
            if (ListCount(outgoing) < 50) {
                ListPrepend(outgoing, message);
            }
                
            printf("Server received '%s' from %ld\n",
                   message, sender);
        
            if (0 != Reply(sender, (void*)&STD_RPLY, msgLength)) {
                printf("Server reply failed\n");
            }
        }
        else
        if (sender == sSendDataPID) {
            stdMsg = (int*) received;
            printf("Server received '%d' from %ld\n",
                   *stdMsg, sender);

            if (ListCount(outgoing) > 0) {
                reply = ListTrim(outgoing);
            }
            msgLength = strlen(reply);
            if (0 != Reply(sender, (void*)reply, msgLength)) {
                printf("Server reply failed\n");
            }
        }
        else
        if (sender == sGetDataPID) {
            message = (char*) received;
            printf("Server received '%s' from %ld\n",
                   message, sender);
            
            if (0 != Reply(sender, (void*)&STD_RPLY, msgLength)) {
                printf("Server reply failed\n");
            }
        }
        else
        if (sender == sDisplayDataPID) {
            stdMsg = (int*) received;
            printf("Server received '%d' from %ld\n",
                   *stdMsg, sender);
            
            msgLength = strlen(reply);
            if (0 != Reply(sender, (void*)reply, msgLength)) {
                printf("Server reply failed\n");
            }
        }
        else {
            if (0 != Reply(sender, (void*)&STD_RPLY, msgLength)) {
                printf("Server reply failed\n");
            }
        }
    }

}

/* sSendData -- takes data packages from the server
 * and sends them to remote UNIX processes using
 * UDP protocol */
void sSendData() {
    int msgLength;
    void* reply;
    char* message;

    for (;;) {
        reply = Send(sServerPID, (void*)&STD_MSG, &msgLength);
        if (*(int*)reply == NOSUCHPROC) {
            printf("SendData send failed\n");
        }
        else {
            message = (char*)reply;
            printf("SendData received reply '%s'\n", message);
        }
    }
 
}

/* sGetData -- listens on the specified port for
 * UDP data packets and retrieves them */
void sGetData() {
    int msgLength;
    int *reply;
    char* message;

    message = "hello";
    msgLength = strlen(message);

    for (;;) {
        reply = (int*)Send(sServerPID, (void*)message, &msgLength);
        if (*reply == NOSUCHPROC) {
            printf("GetInput send failed\n");
        }
        else {
            printf("GetData received reply '%d'\n", *reply);
        }
    }

}

/* sDisplayData -- prints messages received from
 * the network to the local terminal */
void sDisplayData() {
    int msgLength;
    void* reply;
    char* message;

    for (;;) {
        reply = Send(sServerPID, (void*)&STD_MSG, &msgLength);
        if (*(int*)reply == NOSUCHPROC) {
            printf("DisplayData send failed\n");
        }
        else {
            message = (char*)reply;
            printf("DisplayData received reply '%s'\n", message);
        }
    }
 
}

