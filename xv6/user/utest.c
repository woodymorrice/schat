#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "user/grind.h"
#include <stddef.h>



#define MAX_SLEEP 20
#define MAX_PROC 3

int arrProc[MAX_PROC];

void createProcess() {
    int index;
    int randVal; 
    for (index = 0; index < MAX_PROC; index ++) {
        int process = fork();
        arrProc[index] = process;
        if (process == 0) {
            printf("Process: %ld is sleeping\n", process);
            randVal = rand();
            sleep(randVal * MAX_SLEEP);
        }
    }
}


int tmain() {

    createProcess();

    return 0;
}
