/* CMPT332 - Group 14
 * Phong Thanh Nguyen (David) - wdz468 - 11310824
 * Woody Morrice - wam553 - 11071060 */

#include <stdio.h>

#include <standards.h>
#include <os.h>

void sServer();
void sGetInput();
void sSendData();
void sGetData();
void sDisplayData();

int mainp() {
    Create((void(*)())sServer, 65536,
           "sServer", NULL, NORM, USR);
    Create((void(*)())sGetInput, 65536,
           "sGetInput", NULL, NORM, USR);
    Create((void(*)())sSendData, 65536,
           "sSendData", NULL, NORM, USR);
    Create((void(*)())sGetData, 65536,
           "sGetData", NULL, NORM, USR);
    Create((void(*)())sDisplayData, 65536,
           "sDisplayData", NULL, NORM, USR);

    return 0;
}


/* sGetInput -- waits on input from the keyboard,
 * takes input and packages it into a message to
 * send to the server upon newline */
void sGetInput() {
    printf("sGetInput() thread reached\n");

}

/* sServer -- coordinates the sending of messages
 * by managing a list of messages from sGetInput()
 * and serving those messages to sSendData() */
void sServer() {
    printf("sServer() thread reached\n");

}

/* sSendData -- takes data packages from the server
 * and sends them to remote UNIX processes using
 * UDP protocol */
void sSendData() {
    printf("sSendData() thread reached\n");

}

/* sGetData -- listens on the specified port for
 * UDP data packets and retrieves them */
void sGetData() {
    printf("sGetData() thread reached\n");

}

/* sDisplayData -- prints messages received from
 * the network to the local terminal */
void sDisplayData() {
    printf("sDisplayData() thread reached\n");

}

