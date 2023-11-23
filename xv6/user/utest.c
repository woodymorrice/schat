#include "kernel/types.h"
#include "kernel/stat.h"
#include "kernel/param.h"
#include "user/user.h"
#include "user/grind.h"
#include "user/square.h"
#include <stddef.h>

#define MAX_SLEEP 20
#define MAX_PROC 3
#define MAX_RAND 800 

void parentProc() {
    int index, n1, n2, n3;
    int pid1, pid2, pid3;
    
    pid1 = fork();
       
    if (pid1 < 0) {
        printf("pid1: fork fail\n");
        exit(-1);
    }

    if(pid1 == 0) {
        pid2 = fork();
        if (pid2 < 0) {
            printf("pid2: fork fail\n");
            exit(-1);
        }
        if (pid2 == 0) {
            pid3 = fork();
            if (pid3 < 0) {
                printf("pid3: fork fail\n");
                exit(-1);
            }
            if (pid3 == 0) {
                n1 = rand() % MAX_RAND;
                sleep(rand() * MAX_SLEEP);
                for(index = 0; index < n1; index ++) {
                    square(index);
                }
                printf("pid3: square calls: %d.\n", n1);
                exit(0);
            }
            else{
                wait(0);
            }
        
        }
        else {
            wait(0);
            n2 = rand() % MAX_RAND;
            sleep(rand() * MAX_SLEEP);
            for (index = 0; index < n2; index ++) { 
                square(index);
            }
            
            printf("pid2: square calls: %d.\n", n2);
            exit(0);
            }
    }

    else {
        wait(0);
        n3 = rand() % MAX_RAND;
        sleep(rand() * MAX_SLEEP);
        for(index = 0; index < n3; index ++) {
            square(index);
        }
        printf("pid1: square calls: %d.\n", n3);
        exit(0); 
    } 
}

int pmain() {

    parentProc();

    exit(0);
}
