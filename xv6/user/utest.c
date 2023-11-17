#include "kernel/types.h"
#include "user/user.h"
#include "user/grind.h"
#include <stddef.h>



#define MAX_SLEEP 20
#define MAX_PROC 3

int arrProc[MAX_PROC];

void createProcess() {
    int index; 
    for (index = 0; index < MAX_PROC; index ++) {
        int process = fork();
        arrProc[index] = process;
        if (process == 0) {
            printf("Process: %ld is sleeping\n", process);
            sleep(rand() * MAX_SLEEP);
        }
    }
}


int main() {

    createProcess();

    return 0;
}
