/*
 * Lab 6: Scheduler Simulator
 * CMPT 332 Fall 2018
 * University of Saskatchewan
 */

#include <stdio.h>

#include <os.h>

#include <list.h>

#define SCHEDULER_QUANTUM 25

#define BLOCK_MAXIMUM 50
#define BLOCK_CHANCE 3
#define WORK_MAXIMUM 50

LIST *q0,*q1,*q2,*q3,*q4;

int get_priority();

void panic(const char *msg) {
    fprintf(stderr, "[PANIC] %s\n", msg);
    exit(1);
}

void error(const char *msg) {
    fprintf(stderr, "[ERROR] %s\n", msg);
}

enum pstate {NONE, RUNNING, RUNNABLE, BLOCKING};

struct proc {
    PID pid;
    enum pstate state;
    int priority;
};

static int ncpu;

static struct {
    int mutex;
    int running;
    struct proc *procs;
    size_t size;
} ptable;

static PID scheduler_pid;

/* Returns the next process to run or NULL if there is nothing runnable */
struct proc *next_proc() {

    /* TODO: reimplement as a priority scheduler */

    /*
     * Checking through every queue based on the process's priority
     * return the process address   
    */
    if (ListCount(q0) > 0) {
        return ((struct proc*)(ListTrim(q0)));
    }        
    if (ListCount(q1) > 0) {
        return ((struct proc*)(ListTrim(q1)));
    }   
    if (ListCount(q2) > 0) {
        return ((struct proc*)(ListTrim(q2)));
    }   
    if (ListCount(q3) > 0) {
        return ((struct proc*)(ListTrim(q3)));
    }   
    if (ListCount(q4) > 0) {
        return ((struct proc*)(ListTrim(q4)));
    }   

    return NULL;
}

/* Scheduler entrypoint */
void scheduler() {
    struct proc *p;
    /*
     * Initialize priority queues 
    */
    q0 = ListCreate();
    q1 = ListCreate();
    q2 = ListCreate();
    q3 = ListCreate();
    q4 = ListCreate();

    for (;;) {
        if (P(ptable.mutex)) panic("invalid ptable mutex");

        while (ptable.running < ncpu) {
            p = next_proc();
            if (!p) break;
            if (Resume(p->pid)) continue;
            p->state = RUNNING;
            ptable.running += 1;
        }

        if (V(ptable.mutex)) panic("invalid ptable mutex");

        Sleep(SCHEDULER_QUANTUM);
    }
}

/* Sets the process state */
void set_state(enum pstate state) {
    PID pid;
    struct proc *p;
    int prio;

    pid = MyPid();

    if (state == RUNNING && pid != scheduler_pid)
        panic("only the scheduler can set things to running!");

    if (P(ptable.mutex)) panic("invalid ptable mutex");

    for (p = ptable.procs; p < &ptable.procs[ptable.size]; p++) {
        if (p->pid != pid) continue;

        /* Don't do anything because it's not going to change... */
        if (p->state == state) break;

        if (p->state == RUNNING) {
            ptable.running -= 1;
        }

        if (state == RUNNABLE) {
            /* TODO: add to runnable queue */
            /*
            * Adding runnable process to queue based on its priority
            */
            prio = p->priority;
            switch (prio) {
                case 0:
                    ListPrepend(q0, p);
                    break;
                case 1:
                    ListPrepend(q1, p);
                    break;
                case 2:
                    ListPrepend(q2, p);
                    break;
                case 3:
                    ListPrepend(q3, p);
                    break;
                case 4:
                    ListPrepend(q4, p);
                    break;
            }
        }

        p->state = state;
        break;
    }

    if (V(ptable.mutex)) panic("invalid ptable mutex");
}

/* Returns the priority of the calling process */
int get_priority() {
    PID pid;
    struct proc *p;
    int priority = -1;

    pid = MyPid();

    if (P(ptable.mutex)) panic("invalid ptable mutex");

    for (p = ptable.procs; p < &ptable.procs[ptable.size]; p++) {
        if (p->pid != pid) continue;
        priority = p->priority;
        break;
    }

    if (V(ptable.mutex)) panic("invalid ptable mutex");

    return priority;
}

/* Causes the running process to yield to others */
void yield() {
    set_state(RUNNABLE);
    Suspend();
}

/* Simulates a blocking call */
void block(unsigned int time) {
    set_state(BLOCKING);
    Sleep(time);
    yield();
}

/* Process entry point */
void process(void *arg) {
    char *name = (char *) arg;

    set_state(RUNNABLE);
    /* We need to wait for the scheduler to let us start. */
    Suspend();

    for (;;) {
        if (rand() % BLOCK_CHANCE == 0) {
            printf("%s is start block.\n", name);
            block(rand() % BLOCK_MAXIMUM);
            printf("%s is done blocking.\n", name);
        } else {
            printf("%s is running. (priority %d)\n", name, get_priority());
            Sleep(rand() % WORK_MAXIMUM);
            yield();
        }
    }
}

int mainp(int argc, char **argv) {
    PID pid;
    char *name;
    long unsigned int i;
    struct proc *p;

    srand(0);

    if (argc != 3) {
        printf("usage: %s nproc ncpu\n", argv[0]);
        exit(1);
    }

    ptable.size = atoi(argv[1]);
    if (ptable.size <= 0) {
        printf("nproc must be greater than 0\n");
        exit(1);
    }

    ncpu = atoi(argv[2]);
    if (ncpu <= 0) {
        printf("ncpu must be greater than 0\n");
        exit(1);
    }

    ptable.running = 0;
    ptable.procs = calloc(sizeof(struct proc), ptable.size);
    if (ptable.procs == NULL) {
        panic("Unable to allocate ptable.");
    }

    ptable.mutex = NewSem(1);
    if (ptable.mutex == -1) {
        panic("Unable to create semaphore for ptable.");
    }

    scheduler_pid = Create(scheduler, 4096, "scheduler", NULL, HIGH, USR);
    if (scheduler_pid == PNUL) {
        panic("Unable to create scheduler thread.");
    }

    for (i = 0; i < ptable.size; i++) {
        name = malloc(32);
        if (name == NULL) {
            panic("Unable to allocate memory for name");
        }
        sprintf(name, "process_%ld", i);

        pid = Create(process, 4096, name, name, NORM, USR);
        if (pid == PNUL) {
            panic("Unable to create thread for process.");
        }

        p = &ptable.procs[i];
        p->pid = pid;
        p->state = NONE;
        p->priority = rand() % 5;
    }

    return 0;
}
