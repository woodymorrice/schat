#include "kernel/types.h"
#include "kernel/stat.h"
#include "kernel/param.h"
#include "user/user.h"
#include "user/grind.h"
#include "user/square.h"
#include <stddef.h>

#define MAX_SLEEP 20
#define SLEEP 4

void childProc1();
void childProc2();

void parentProc() {
    int randSleep;
    int randVal;
    int index;
    int pid;
    pid = fork();
    if (pid > 0) {
        randVal = rand();
        randSleep = rand() * MAX_SLEEP;
        sleep(randSleep);
        printf("Process: %d is running\n", pid);
        for(index = 0; index < randVal; index ++) {
            square(index);
        }
        childProc1();
    }
}

void childProc1() {
    int randSleep;
    int randVal;
    int index;
    int pid;
    pid = fork();
    if (pid > 0) {
        randVal = rand();
        randSleep = rand() * MAX_SLEEP;
        sleep(randSleep);
        printf("Process: %d is running\n", pid);
        for(index = 0; index < randVal; index ++) {
            square(index);
        }
        childProc2();
    } 
}

void childProc2() {
    int randSleep;
    int randVal;
    int index;
    int pid;
    pid = fork();
    if (pid > 0) {
        randVal = rand();
        randSleep = rand() * MAX_SLEEP;
        sleep(randSleep);
        printf("Process: %d is running\n", pid);
        for(index = 0; index < randVal; index ++) {
            square(index);
        }
    } 
}


int pmain() {

    parentProc();

    exit(0);
}
