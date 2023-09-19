/* CMPT332 - Group 14
 * Phong Thanh Nguyen (David) - wdz468 - 11310824
 * Woody Morrice - wam553 - 11071060 */

#include <Windows.h>
#include <stdio.h>
#include <stdlib.h>

#include <square.h>

/* the number of args to sent to parentThread */
#define NUMARGS 3

DWORD WINAPI parentThread(LPVOID lPtr) {
    int* args;
    args = (int*) lPtr;

    if (args[0] < 0) {
        printf("Error in procedure parentThread: invalid parameter threads");
        return EXIT_FAILURE;
    } else {
        printf("Got to procedure parentThread()\n");
    }

    
    if (args[1] < 0) {
        printf("Error in procedure parentThread: invalid parameter deadline");
        return EXIT_FAILURE;
    } else {
        printf("Got to procedure parentThread()\n");
    }

    return EXIT_SUCCESS;
}

DWORD WINAPI childThread(LPVOID lPtr) {
    int* args;
    args = (int*) lPtr;

    if (args[2] < 0) {
        printf("Error in procedure childThread: invalid parameter size");
        return EXIT_FAILURE;
    } else {
        printf("Got to procedure childThread()\n");
    }

    return EXIT_SUCCESS;
}


int main(int argc, char* argv[]) {

    /* array of args to pass to parentThread */
    int args[NUMARGS];

    /* handles for threads, 2 for testing */
    HANDLE winThread[2];

    int i;

    if (argc != 4) {
        printf("Error in procedure main(): invalid number of parameters\n");
        return EXIT_FAILURE;
    } else {
        printf("Got to procedure main()\n");
    }

    if (argc == 4) {
        args[0] = atoi(argv[1]);
        args[1] = atoi(argv[2]);
        args[2] = atoi(argv[3]);
    }
    
    /* Test square() */
    square(args[0]);


    winThread[0] = CreateThread(NULL, 0, parentThread, args, 0, NULL);
    winThread[1] = CreateThread(NULL, 0, childThread, args, 0, NULL);

    for(i = 0; i < 2; i++) {
        if (winThread[i] == NULL) {
            printf("Error creating thread");
        }
    }

    return EXIT_SUCCESS;
}

