#include "kernel/types.h"
#include "user/user.h"


#define MAX_SLEEP 20



void createProccess() {
    PID process = fork();
    if (process != NULL) {
        sleep(rand() * MAX_SLEEP);
        if (process->state == RUNNABLE) {
            
        }
    }

    
    return process;

}


int main() {

    PID process1 = createProcess();

    PID process2 = createProcess();

    PID process3 = createProcess();

    return 0;
}
