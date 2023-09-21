/* CMPT332 - Group 14
 * Phong Thanh Nguyen (David) - wdz468 - 11310824
 * Woody Morrice - wam553 - 11071060 */

#include <Windows.h>
/*#include <sysinfoapi.h>
#include <synchapi.h> */

#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

#include <square.h>
#include <htable.h>

/* the number of args to sent to parentThread */
#define NUMARGS 3

/* hashtable size */
#define HT_SIZE 50

/* global flag for child threads */
bool keepRunning;

/* hashtable for storing invocations of square
 * for each thread */
int sqCalls[HT_SIZE];

DWORD threadIdArr[HT_SIZE];

int hashFunc(unsigned long int threadId) {
    printf("%ld\n", threadId);
    return EXIT_SUCCESS;
}


DWORD WINAPI childThread(LPVOID lPtr) {
    int* args;
    int i;
    ULONGLONG beginTime;
    ULONGLONG endTime;
    ULONGLONG elapsed;

    printf("childThread reached\n");

    beginTime = GetTickCount64();
    
    args = (int*) lPtr;

    if (args[2] < 0) {
        printf("Error in procedure parentThread: invalid parameter size\n");
    }

    while (keepRunning) {
        for (i = 0; i <= args[2]; i++) {
    /*  for (i = 1; i <= args[2]; i++) { // test this */
            square(i);
        }
    }
    
    endTime = GetTickCount64();
    elapsed = endTime - beginTime;

    printf("Elapsed: %d\n", (unsigned)elapsed);
        
    return EXIT_SUCCESS;
}

DWORD WINAPI parentThread(LPVOID lPtr) {
    int* args;
    int i;
    
    printf("parentThread reached\n");

    args = (int*)lPtr;

    if (args[0] < 0) {
        printf("Error in procedure parentThread: invalid parameter threads\n");
    }
    
    if (args[1] < 0) {
        printf("Error in procedure parentThread: invalid parameter deadline\n");
    }

    for (i = 0; i < args[0]; i++) {
        CreateThread(NULL, 0, childThread, args, 0, &threadIdArr[i]);
        hashFunc(threadIdArr[i]);
    }

    Sleep(args[1]);

    keepRunning = false;

    return EXIT_SUCCESS;
}

int main(int argc, char* argv[]) {

    /* array of args to pass to parentThread */
    int args[NUMARGS];

    HANDLE pThread;

    keepRunning = true;

    if (argc != 4) {
        printf("Error in procedure main(): invalid number of parameters\n");
    }

    if (argc == 4) {
        args[0] = atoi(argv[1]);
        args[1] = atoi(argv[2]);
        args[2] = atoi(argv[3]);
    }

    pThread = CreateThread(NULL, 0, parentThread, args, 0, NULL);

    if (pThread == NULL) {
        printf("Error creating parent thread\n");
    }

    printf("Exiting main\n");

    return EXIT_SUCCESS;
}

