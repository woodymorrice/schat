/* CMPT332 - Group 14
 * Phong Thanh Nguyen (David) - wdz468 - 11310824
 * Woody Morrice - wam553 - 11071060 */

/* List Library provided with consent by
 * Joseph Medernach, imy309, 11313955
 * John Miller, knp254, 11323966 */

#include <unistd.h>
#include <fcntl.h>
#include <stdio.h>
#include <string.h>
#include <stdbool.h>

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
    char buf[256];
    int msgLength;
    int *reply;

    fcntl(0, F_SETFL, fcntl(0, F_GETFL) | O_NONBLOCK);

    for (;;) {

        msgLength = read(0, buf, MAX_LEN);
            
        if (msgLength > 0) {
            buf[msgLength] = '\0';
            
            if (strncmp("exit\n", buf, msgLength) == 0 ||
                strncmp("quit\n", buf, msgLength) == 0) {

                fcntl(0, F_SETFL, fcntl(0, F_GETFL) | ~O_NONBLOCK);
                exit(0);
            }

            reply = (int*)Send(sServerPID, (void*)&buf, &msgLength);
            if (*reply == NOSUCHPROC) {
                printf("GetInput send failed\n");
                exit(-1);
            }
        }
    }

}

/* sServer -- coordinates the sending of messages
 * by managing a list of messages from sGetInput()
 * and serving those messages to sSendData() */
void sServer() {
    PID sender;
    int msgLength;

    LIST *outgoing, *incoming;
    bool  sendWait,  dispWait;

    void *received;
    char *message, *reply;

    reply = "goodbye";

    outgoing = ListCreate();
    sendWait = false;
    
    incoming = ListCreate();
    dispWait = false;

    for (;;) {
        received = Receive(&sender, &msgLength);

        /* Sending messages */
        if (sender == sGetInputPID) {
            message = (char*)received;
            if (ListCount(outgoing) < 50) {
                ListPrepend(outgoing, message);
            }
                
            if (0 != Reply(sender, (void*)&STD_RPLY, msgLength)) {
                printf("Server reply failed\n");
                exit(-1);
            }

            if (sendWait == true && ListCount(outgoing) > 0) {
                reply = ListTrim(outgoing);

                msgLength = strlen(reply);
                if (0 != Reply(sSendDataPID, (void*)reply, msgLength)) {
                    printf("Server reply failed\n");
                    exit(-1);
                }
                sendWait = false;
            }
        }
        else
        if (sender == sSendDataPID) {
            sendWait = true;
        }
        /* Receiving messages */
        else
        if (sender == sGetDataPID) {
            message = (char*)received;
            if (ListCount(incoming) < 50) {
                ListPrepend(incoming, message);
            }
            
            if (0 != Reply(sender, (void*)&STD_RPLY, msgLength)) {
                printf("Server reply failed\n");
                exit(-1);
            }
            
            if (dispWait == true && ListCount(incoming) > 0) {
                reply = ListTrim(incoming);

                msgLength = strlen(reply);
                if (0 != Reply(sDisplayDataPID, (void*)reply, msgLength)) {
                    printf("Server reply failed\n");
                    exit(-1);
                }
           
                dispWait = false;
            }
        }
        else
        if (sender == sDisplayDataPID) {
            dispWait = true;
        }
        /* Should never reach this point */
        else {
            fprintf(stderr, "Server Error: unknown sender\n"); 
            exit(-1);
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
            exit(-1);
        }
        else {
            message = (char*)reply;
            printf("%s", message);
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
            exit(-1);
        }
    }

}

/* sDisplayData -- prints messages received from
 * the network to the local terminal */
void sDisplayData() {
    int msgLength;
    void* reply;
    /*char* message;*/

    for (;;) {
        reply = Send(sServerPID, (void*)&STD_MSG, &msgLength);
        if (*(int*)reply == NOSUCHPROC) {
            printf("DisplayData send failed\n");
            exit(-1);
        }
        else {
            /*message = (char*)reply;*/
            /*printf("DisplayData received reply '%s'\n", message);*/
            /*printf("%s\n", message); */
        }
    }
 
}

