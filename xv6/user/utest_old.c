#include "kernel/types.h"
#include "kernel/stat.h"
#include "kernel/param.h"
#include "user/user.h"
#include "user/grind.h"
#include "user/square.h"
#include <stddef.h>#include "kernel/types.h"                                                       
#include "kernel/stat.h"                                                        
#include "kernel/param.h"                                                       
#include "user/user.h"                                                          
#include "user/grind.h"                                                         
#include "user/square.h"                                                        
#include <stddef.h> 

#define MAX_SLEEP 20
#define MAX_PROC 3
#define MAX_RAND 800 

int parentID[MAX_PROC];

int parentProc(int children) {
    int index, pid, randVal, randSleep;
    
    if (children == 0) {
        return -1;     
    }
    
    pid = fork();
    parentID[MAX_PROC - children] = getpid(); 
       
    if (pid < 0) {
        printf("pid: fork fail\n");
        exit(-1);
    }

    if(pid == 0) {
        
        randVal = rand() % MAX_RAND;
        randSleep = rand() * MAX_SLEEP;

        sleep(randSleep);
        for(index = 0; index < randVal; index ++) {
            square(index);
        }
        if( children == MAX_PROC ) {
            printf("Child with PID: %d,", getpid());
            printf(" and my parent ID: %d,", parentID[MAX_PROC - children]);
            printf(" square calls: %d\n", randVal);
        }
        else {
            printf("Child with PID: %d,", getpid());
            printf(" and parent ID: %d,", parentID[MAX_PROC - (children + 1)]);
            printf(" square calls: %d\n", randVal); 
        }
    
        children --;

        exit(0);
    }
    
    else {
        parentProc(children-1);
        /*wait((int*)0);*/
    }
    
   return 0;
    
}

int pmain() {

    parentProc(3);

    exit(0);
}