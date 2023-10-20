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
const char* STD_MSG = "0";
const char* STD_RPLY = "0";

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
    int msgLen;

    fcntl(0, F_SETFL, fcntl(0, F_GETFL) | O_NONBLOCK);

    for (;;) {
        //buf[0] = '\0';
        msgLen = read(0, buf, MAX_LEN);
        buf[msgLen+1] = '\0';
        
        if (msgLen > 0) {

            //msgLen++;

            if (strncmp("exit\n", buf, msgLen) == 0 ||
                strncmp("quit\n", buf, msgLen) == 0) {
                fcntl(0, F_SETFL, fcntl(0, F_GETFL) | ~O_NONBLOCK);
                exit(0);
            }

            /* for debugging (remove later) */
            write(1, buf, msgLen);

            if (*(int*)Send(sServerPID, &buf, &msgLen)
                    == NOSUCHPROC) {
                fprintf(stderr,
                        "Error: sGetInput invalid send PID\n");
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
    char* message;

    int msgLen;
    int index;

    outgoing = ListCreate();
    /* incoming = ListCreate(); */

    index = 0;
    printf("sServer() thread reached\n");

    for (;;) {

        /* get input */
        message = (char*)Receive(&sGetInputPID, &msgLen);
        outArr[index] = malloc(strlen(message)+1);
        strcpy(message, outArr[index]);
        if (msgLen > 0) {
            //printf("%s", message);
            //outArr[index] = malloc(sizeof(message));
            printf("%s", outArr[index]);
        }
        /*printf("%s\n", (char*)Receive(&sGetInputPID, &msgLen));
        */
        /*msgLen = 0;
        outArr[index] = strndup((char*)
                Receive(&sGetInputPID, &msgLen), msgLen);
        if (msgLen > 0) {
            printf("%s\n", outArr[index]);
        }
        ListPrepend(outgoing, &outArr[index]); */
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
            fprintf(stderr,
                "Error: sSendData invalid send PID\n");
            exit(0);   
        }
        message = (char*)Receive(&sServerPID, &msgLen);
        if (message != STD_RPLY) {
            fprintf(stderr, 
                    "Error: sSendData received erroneous reply\n");
        }
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
            fprintf(stderr,
                "Error: sGetData invalid send PID\n");
            exit(0);   
        }
        message = (char*)Receive(&sServerPID, &msgLen);
        if (message != STD_RPLY) {
            fprintf(stderr,
                "Error: sGetData received erroneous reply\n");
        }

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
            fprintf(stderr,
                "Error: sDisplayData invalid send PID\n");
            exit(0);   
        }
        message = (char*)Receive(&sServerPID, &msgLen);
        if (message != STD_RPLY) {
            fprintf(stderr,
                "Error: sDisplayData received erroneous reply\n");
        }

    }
}

