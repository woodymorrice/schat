/* CMPT332 - Group 14
 * Phong Thanh Nguyen (David) - wdz468 - 11310824
 * Woody Morrice - wam553 - 11071060 */

/* List Library provided with consent by
 * Joseph Medernach, imy309, 11313955
 * John Miller, knp254, 11323966 */

#include <unistd.h>
#include <errno.h>
#include <fcntl.h>
#include <stdio.h>
#include <string.h>
#include <stdbool.h>

#include <sys/types.h>
#include <sys/socket.h>
#include <sys/poll.h>
#include <sys/time.h>
#include <time.h>
#include <netdb.h>
#include <arpa/inet.h>

#include <standards.h>
#include <os.h>

#include <list.h>

#define BUF_SIZE 256
#define NFDS 1
#define TIMEOUT 0
#define MAX_DEST 2

struct sDgram {
    char message[256]; /* same as BUF_SIZE */
    uint32_t s;
    uint32_t ms;
    /*int32_t s_hi;
    int32_t s_lo;
    int32_t ms_hi;
    int32_t ms_lo;*/
};

/* const ints so they can be pointed to */
const int STD_MSG = 0;
const int STD_RPLY = 0;

void sServer();
void sGetInput();
void sSendData();
void sGetData();
void sDisplayData();
int  prepSocket();
struct sDgram* packDgram(char*);
void printTime(struct sDgram*);

static PID sServerPID;
static PID sGetInputPID;
static PID sSendDataPID;
static PID sGetDataPID;
static PID sDisplayDataPID;

static char hostName[32];
static unsigned short int hostPort;
static char* destName[MAX_DEST];
static unsigned short int destPort[MAX_DEST];
static int destinations;
static int sockfd;

int mainp(int argc, char* argv[]) {
    int i;
    int j;

    /* get ports and names */
    if (argc < 4 || argc > 12 || argc % 2 != 0) {
        printf("s-chat usage: s-chat localport " 
               "destname destport dest2name dest2port...\n");
        exit(-1);
    }
    else {
        destinations = (argc - 2) / 2;
        hostPort = (unsigned short int)atoi(argv[1]);
        if (hostPort < 30001 || hostPort > 40000) {
            fprintf(stderr, "User error: invalid port number, "
                    "must be within the range 30001-40000\n");
            exit(-1);
        }
        j = 0;
        for (i=2; i < argc; i++) {
            destName[j] = argv[i];
            i++;
            destPort[j] = (unsigned short int)atoi(argv[i]);
            if (destPort[j] < 30001 || destPort[j] > 40000) {
                fprintf(stderr, "User error: invalid port number, "
                        "must be within the range 30001-40000\n");
                exit(-1);
            }
            j++;
        }
    }

    /* make threads */
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

/* sGetInput -- waits on input from the keyboard, *
 * takes input and packages it into a message to  *
 * send to the server upon newline                */
void sGetInput() {
    char buf[BUF_SIZE];
    int msgLength;
    int *reply;
    
    /* unblock stdin */
    if (-1 == fcntl(0, F_SETFL, fcntl(0, F_GETFL) | O_NONBLOCK)) {
        fprintf(stderr, "error %d: couldn't set stdin to non-blocking",
                errno);
        exit(-1);
    }

    for (;;) {
        /* get input */
        msgLength = read(0, buf, BUF_SIZE-1);        
        if (msgLength > 0) {
            buf[msgLength] = '\0';
            
            /* exit commands */
            if (strncmp("exit\n", buf, msgLength) == 0 ||
                strncmp("quit\n", buf, msgLength) == 0) {

                fcntl(0, F_SETFL, fcntl(0, F_GETFL) | ~O_NONBLOCK);
                fcntl(sockfd, F_SETFL, fcntl(sockfd, F_GETFL)
                                       | ~O_NONBLOCK);
                exit(0);
            }
            
            /* send input to server */
            reply = (int*)Send(sServerPID, (void*)&buf, &msgLength);
            if (*reply == NOSUCHPROC) {
                printf("GetInput send failed\n");
                exit(-1);
            }
        }
    }
}

/* sServer -- coordinates the sending of messages  *
 * by managing a list of messages from sGetInput() *
 * and serving those messages to sSendData()       */
void sServer() {
    PID sender;
    int msgLength;

    LIST *outgoing, *incoming;
    bool  sendWait,  dispWait;

    void *received, *dReply;
    char *message, *reply;

    /* reply = "goodbye"; */

    outgoing = ListCreate();
    sendWait = false;
    
    incoming = ListCreate();
    dispWait = false;

    sockfd = prepSocket();

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
            if (ListCount(outgoing) > 0) {
                reply = ListTrim(outgoing);

                msgLength = strlen(reply);
                if (0 != Reply(sSendDataPID, (void*)reply, msgLength)) {
                    printf("Server reply failed\n");
                    exit(-1);
                } 
            }
            else {
                sendWait = true;
            }
        }
        /* Receiving messages */
        else
        if (sender == sGetDataPID) {
            if (ListCount(incoming) < 50) {
                ListPrepend(incoming, received);
            }
            
            if (0 != Reply(sender, (void*)&STD_RPLY, msgLength)) {
                printf("Server reply failed\n");
                exit(-1);
            }
            
            if (dispWait == true && ListCount(incoming) > 0) {
                dReply = ListTrim(incoming);

                msgLength = strlen((char*)dReply);
                if (0 != Reply(sDisplayDataPID, dReply, msgLength)) {
                    printf("Server reply failed\n");
                    exit(-1);
                }
           
                dispWait = false;
            }
        }
        else
        if (sender == sDisplayDataPID) {
            if (ListCount(incoming) > 0) {
                dReply = ListTrim(incoming);

                msgLength = strlen((char*)dReply);
                if (0 != Reply(sDisplayDataPID, dReply, msgLength)) {
                    printf("Server reply failed\n");
                    exit(-1);
                } 
            }
            else {
                dispWait = true;
            }
        }
        /* Should never reach this point */
        else {
            fprintf(stderr, "Server Error: unknown sender\n"); 
            exit(-1);
        }
    }
}

/* sSendData -- takes data packages from the server and   *
 * sends them to remote UNIX processes using UDP protocol */
void sSendData() {
    struct hostent *result;
    char buffer[256];
    int bufflen;
    int h_errnop;

    struct in_addr **addrs;
    int i;
    int j;
    char ip_add[INET_ADDRSTRLEN];

    struct sockaddr_in *destPc[MAX_DEST];

    int msgLength;
    void* reply;
    char* message;
    struct sDgram* dataPkg;
    
    struct pollfd *canSend[1];
    int npoll;
    
    result = malloc(sizeof(struct hostent));

    for (i = 0; i < destinations; i++) {

        /* printf("'%s' %u\n", destName[i], destPort[i]); */
    
        /*result = malloc(sizeof(struct hostent));*/

        /*memset(buffer, '\0', 256);*/
    
        /* getting the network host entry information */
        bufflen = 256;
        h_errnop = 0;
        if (0 != gethostbyname_r(destName[i], result,
                                 buffer, bufflen,
                                 &result, &h_errnop)) {
            fprintf(stderr, "error: couldnt get network host entry\n");
            exit(-1);
        }

        if (result == NULL) {
            fprintf(stderr, "User error: no host by the name \"%s\"\n",
                    destName[i]);
            exit(-1);
        }
    
        /* prints the list of IP addresses for debugging */
        /* memset(ip_add, 0, INET_ADDRSTRLEN); */
        addrs = (struct in_addr **)result->h_addr_list;
        /* for (j = 0; addrs[j] != NULL; j++) {
            inet_ntop(AF_INET, &addrs[j], ip_add, INET_ADDRSTRLEN);
            printf("'%s'\n", ip_add);
        } */

        /* preparing my artisan sockaddr_in struct */
        destPc[i] = malloc(sizeof(struct sockaddr_in));
    
        destPc[i]->sin_family = AF_INET;
        destPc[i]->sin_port = htons(destPort[i]);
        destPc[i]->sin_addr = *addrs[0];

        /*free(result);*/
    }
    
    free(result);
    canSend[0] = malloc(sizeof(struct pollfd));

    canSend[0]->fd = sockfd;
    canSend[0]->events = POLLOUT;

    for (;;) {
        reply = Send(sServerPID, (void*)&STD_MSG, &msgLength);
        if (*(int*)reply == NOSUCHPROC) {
            printf("SendData send failed\n");
            exit(-1);
        }
        else {
            message = (char*)reply;
            dataPkg = packDgram(message);

            npoll = poll(canSend[0], NFDS, TIMEOUT);
            if (npoll == -1) {
                fprintf(stderr, "error %d: send poll failed\n", errno);
                exit(-1);
            }
            else
            if (npoll ==  1) {
                for (i = 0; i < destinations; i++) {
                    if (-1 == sendto(sockfd, (void*)dataPkg,
                                     sizeof(struct sDgram), 0,
                                     (struct sockaddr *)destPc[i],
                                     sizeof(struct sockaddr_in))) {
                        fprintf(stderr, "error %d: sendto failed\n",
                                errno);
                        exit(-1);
                    }
                }
            }
            free(dataPkg);
        }
    }

}

/* sGetData -- listens on the specified port *
 * for UDP data packets and retrieves them   */
void sGetData() {
    int msgLength;
    void *reply;

    struct sDgram* dataPkg;

    struct pollfd *msgWaiting[1];
    int npoll;

    int bytes;

    struct sockaddr_in *from;
    unsigned int fromlen;


    msgWaiting[0] = malloc(sizeof(struct pollfd));

    msgWaiting[0]->fd = sockfd;
    msgWaiting[0]->events = POLLIN;

    from = malloc(sizeof(struct sockaddr_in));
    fromlen = sizeof(struct sockaddr_in);

    for (;;) {
        npoll = poll(msgWaiting[0], NFDS, TIMEOUT);
        if (npoll == -1) {
            fprintf(stderr, "error %d: recv poll failed\n", errno);
            exit(-1);
        }
        else 
        if (npoll ==  1) {
            dataPkg = malloc(sizeof(struct sDgram));
            bytes = recvfrom(sockfd, (void*)dataPkg,
                             sizeof(struct sDgram),
                             0, (struct sockaddr *)from, &fromlen); 
            if (bytes == -1) {
                fprintf(stderr, "error %d: recvfrom failed\n", errno);
                exit(-1);
            }
            msgLength = sizeof(struct sDgram);
            reply = Send(sServerPID, (void*)dataPkg, &msgLength);
            if (*(int*)reply == NOSUCHPROC) {
                printf("GetInput send failed\n");
                exit(-1);
            }
        }
    }
}

/* sDisplayData -- prints messages received *
 * from the network to the local terminal   */
void sDisplayData() {
    int msgLength;
    void* reply;
    struct sDgram* dataPkg;

    for (;;) {
        reply = Send(sServerPID, (void*)&STD_MSG, &msgLength);
        if (*(int*)reply == NOSUCHPROC) {
            printf("DisplayData send failed\n");
            exit(-1);
        }
        else {
            dataPkg = (struct sDgram *)reply;
            printTime(dataPkg);
            printf(": %s", &dataPkg->message[0]);
        }
        free(dataPkg);
    }
}

/* prepSocket -- prepares and returns local network socket */
int prepSocket() {
    /*static char hostname[32];*/ /* for getting the hostname */

    struct hostent *result; /* for grabbing the network host entry */
    char buffer[256];
    int  bufflen;
    int  h_errnop;

    struct in_addr **addrs; /* to print the IP for debugging */
    int i;
    char ip_add[INET_ADDRSTRLEN];

    struct sockaddr_in *hostPc; /* handcrafted */
    int sock; /* socket file descriptor */

    /* getting the hostname */
    if (0 != gethostname(hostName, sizeof(hostName))) {
        fprintf(stderr, "error %d: could not get host name\n", errno);
        exit(-1);
    }
    /* printf("'%s' %u\n", hostName, hostPort); */

    /* getting the network host entry information */
    result = malloc(sizeof(struct hostent));
    bufflen = 256;
    h_errnop = 0;
    if (0 != gethostbyname_r(&hostName[0], result, &buffer[0], bufflen,
                &result, &h_errnop)) {
        fprintf(stderr, "error: could not get network host entry\n");
        exit(-1);
    }
    
    /* prints the list of IP addresses for debugging */
    /* memset(ip_add, 0, INET_ADDRSTRLEN); */
    addrs = (struct in_addr **)result->h_addr_list;
    /* for (i = 0; addrs[i] != NULL; i++) {
        inet_ntop(AF_INET, &addrs[i], ip_add, INET_ADDRSTRLEN);
        printf("'%s'\n", ip_add);
    } */

    /* preparing my artisan sockaddr_in struct */
    hostPc = malloc(sizeof(struct sockaddr_in));
    
    hostPc->sin_family = AF_INET;
    hostPc->sin_port = htons(hostPort);
    hostPc->sin_addr = *addrs[0];
    memset(hostPc->sin_zero, '\0', sizeof(hostPc->sin_zero));

    /* getting the socket file descriptor */
    if (-1 == (sock = socket(PF_INET, SOCK_DGRAM, 0))) {
        fprintf(stderr, "error: could not get socket\n");
        exit(-1);
    }
    
    /* binding the socket to the chosen port */
    if (-1 == bind(sock, (struct sockaddr *)hostPc, sizeof(*hostPc))) {
        fprintf(stderr, "error: could not bind socket\n");
        exit(-1);
    }
    
    /* set the socket to non-blocking */
    if (-1 == fcntl(sock, F_SETFL, fcntl(sock, F_GETFL) | O_NONBLOCK)) {
        fprintf(stderr, "error %d: couldnt set socket to nonblocking\n",
                errno);
        exit(-1);
    }

    return sock;
}

/* packDgram -- takes a string and packs it *
 * into a datagram with time information    */
struct sDgram* packDgram(char* msg) {
    struct sDgram* dgram;
    struct timeval curTime;

    /*int32_t s_hi;
    int32_t s_lo;
    int32_t ms_hi;
    int32_t ms_lo;*/

    gettimeofday(&curTime, NULL);

    dgram = malloc(sizeof(struct sDgram));
    
    memcpy(dgram->message, msg, strlen(msg)+1); 
    dgram->message[strlen(msg)] = '\0';

    /*dgram->secs = (int64_t)htonl(curTime.tv_sec);*/
    /*dgram->ms = (int64_t)htonl(curTime.tv_usec);*/

    /*s_hi = (int32_t)(curTime.tv_sec  >> 32);
    s_lo = (int32_t)(curTime.tv_sec & 0xffffffff);
    ms_hi = (int32_t)((int64_t)curTime.tv_usec >> 32);
    ms_lo = (int32_t)(curTime.tv_usec & 0xffffffff);*/

    dgram->s = htonl(curTime.tv_sec);
    /*dgram->s_hi = htonl(s_hi);
    dgram->s_lo = htonl(s_lo);
    dgram->ms_hi = htonl(ms_hi);
    dgram->ms_lo = htonl(ms_lo);*/
    dgram->ms = htonl((uint32_t)curTime.tv_usec);

    return dgram;
}

/* printTime -- prints the date in a nice format */
void printTime(struct sDgram* time) {
    long int s;

    /*time_t secs;*/
    uint32_t ms;
    char str[64];
    struct tm timeptr;

    s = (signed long)ntohl(time->s);
    ms = ntohl(time->ms);
    /*ms = ntohll(time->ms);*/
    /*s = (((int64_t)ntohl(time->s_hi)) << 32) + ntohl(time->s_lo);*/
    /*ms = (((int64_t)ntohl(time->ms_hi)) << 32) | ntohl(time->ms_lo);*/

    timeptr = *localtime(&s);
    strftime(str, sizeof(str), "%x %X", &timeptr);

    printf("%s.%d", str, ms);
}

