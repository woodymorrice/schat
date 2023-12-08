/* CMPT332 - Group 14
 * Phong Thanh Nguyen (David) - wdz468 - 11310824
 * Woody Morrice - wam553 - 11071060 */

/* All the list source code files on the behalf of:
 * Joseph Medernach, imy309, 11313955
 * John Miller, knp254, 11323966
 */
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <sys/stat.h>

#include <rtthreads.h>
#include <RttCommon.h>

#include <list.h>
#include <random.h>
#include <monitor.h>
#include <memmonitor.h>

#include <defs.h>

static int reqs;
static int fin;
static int memAlg;
static LIST* stats;


void sim_proc(void* num) {
    int* args;
    char procnum[THRD_NMSZ];
    FILE* f;
    int i, alloc, sz, slp, randFree, n, j;
    LIST* blocks;
    memBlock* block;
    memStat* curStat;

    /* args[0] = algorithm, args[1] = proc number */
    args = (int*)num;
    blocks = ListCreate();
    
    /* get the name of the random # input file */
    if (snprintf(procnum, sizeof(procnum), "./tmp/%d.txt", args[1]) == 0) {
        fprintf(stderr, "snprintf failed in sim_proc()\n");
        exit(EXIT_FAILURE);
    }
    /* open its generated random nums */
    if((f = fopen(procnum, "r")) == NULL) {
        fprintf(stderr, "fopen failed in sim_proc()\n");
        exit(EXIT_FAILURE);
    }
    /* iterate through the random numbers */
    for (i = 0; i < NRAND*reqs; i++) {
        /* read a line from the file */
        if (fscanf(f, "%d ", &n) != 1) {
            fprintf(stderr, "fscanf failed in sim_proc()\n");
            perror("");
            exit(EXIT_FAILURE);   
        }
        /* alloc or free? */
        if      (i % NRAND == 0) {
            alloc = n;
        }
        else if (i % NRAND == 1) {
            sz = n;
            if (ListCount(blocks) < 1) {
                alloc = 1;
            }
            if (alloc) {
                /*printf("Proc %d Block Size: %d Mbs\n", (int)id, sz);*/
                block = MyMalloc(args[0], sz);
                if (block == NULL) {
                    fprintf(stderr, "MyMalloc failed in sim_proc()\n");
                    exit(EXIT_FAILURE);
                }
                ListPrepend(blocks, block);
            }
            else {
                randFree = (int)(rand() % ListCount(blocks));
                block = ListFirst(blocks);
                for (j = 0; j < randFree; j++) {
                    block = ListNext(blocks);
                }
                if (block == NULL) {
                    fprintf(stderr, "no block to free (bad)\n");
                    exit(EXIT_FAILURE);

                }
                if (MyFree(block->startAddr) != 0) {
                    fprintf(stderr, "Free failed in sim_proc()\n");
                    exit(EXIT_FAILURE);
                }
                ListRemove(blocks);
            }
        }
        else if (i % NRAND == 2) {
            slp = n;
            /*printf("Proc %d Sleeping for %d seconds\n", (int)id, slp);*/
            RttUSleep(((unsigned)slp)*1000);
        }
        else {
            fprintf(stderr, "fatal error in sim_proc()\n");
            exit(EXIT_FAILURE);
        }
    }
    free(args); /*cant check return value :( */
    if (fclose(f) != 0) {
        fprintf(stderr, "fclose failed in sim_proc()\n");
        exit(EXIT_FAILURE); 
    }
    fin += 1;
    if (fin == NUM_THRDS) {
        printf("%d,%d,", NUM_THRDS, reqs); 
        memPrinter();
        curStat = malloc(sizeof(memStat));
        ListPrepend(stats, MyMemStats(memAlg, 0, curStat));
        exit(0);
    }
    RttExit();
}

void getInput() {
    char buf[BUF_SIZE];
    int msgLength;
    memStat* curStat;
                                                                          
    /* unblock stdin */                                                         
    if (-1 == fcntl(0, F_SETFL, fcntl(0, F_GETFL) | O_NONBLOCK)) {              
        fprintf(stderr, "error %d: couldn't set stdin to non-blocking",         
                errno);                                                         
        exit(EXIT_FAILURE);
    }                                                        
    for (;;) {                                                                  
        /* get input */             
        msgLength = read(0, buf, BUF_SIZE-1);                                   
        if (msgLength > 0) {                                                    
            buf[msgLength] = '\0';                                              
                                                                                
            /* exit commands */                                                 
            if (strncmp("exit\n", buf, msgLength) == 0 ||                       
                strncmp("quit\n", buf, msgLength) == 0) {                       
                                                                                
                fcntl(0, F_SETFL, fcntl(0, F_GETFL) | ~O_NONBLOCK);
                exit(0);                            
            }
            else if (strncmp("stats\n", buf, msgLength) == 0) {
                memPrinter();
                curStat = malloc(sizeof(memStat));
                ListPrepend(stats, MyMemStats(memAlg, 0, curStat));
            }                                               
        }                                                                       
    }                                                                           
}

void unblocker() {
    unblock();
    RttSleep(5);
}

int init_thrds(int algo) {
    int i, thread;
    char buf[THRD_NMSZ];
    RttThreadId id;
    RttSchAttr attr;
    int* thrd_args;

    attr.startingtime = RTTZEROTIME;
    attr.priority = RTTNORM;
    attr.deadline = RTTNODEADLINE;

    fin = 0;
    memInit();

    for (i = 0; i < NUM_THRDS; i++) {
        /* threadname = same as rndm num file it will read */
        if (snprintf(buf, sizeof(buf), "%d", i) == 0) {
            fprintf(stderr, "snprintf failed in init_thrds()\n");
            return EXIT_FAILURE;
        }
        /* set args */
        thrd_args = malloc(NTHRDARGS*sizeof(int));
        thrd_args[0] = algo;
        thrd_args[1] = i;

        /* create the thread */
        thread = RttCreate(&id, sim_proc, STKSIZE,
                           buf, (void*)thrd_args, attr, RTTUSR);
        if (thread == RTTFAILED) {
            fprintf(stderr, "RttCreate() failed on thread %d\n", i);
            exit(EXIT_FAILURE);
        }        
    }

    /* unblocker, might not be necessary */
    /*thread = RttCreate(&id, unblocker, STKSIZE,
                       "unblocker", NULL, attr, RTTUSR);
    if (thread == RTTFAILED) {
        fprintf(stderr, "RttCreate() failed on thread %d\n", i);
        exit(EXIT_FAILURE);
    }*/
    /* user input thread */
    attr.priority = RTTLOW;
    thread = RttCreate(&id, getInput, STKSIZE,
                       "input", NULL, attr, RTTUSR);
    if (thread == RTTFAILED) {
        fprintf(stderr, "RttCreate() failed on thread %d\n", i);
        exit(EXIT_FAILURE);
    }
    return EXIT_SUCCESS;
}

int gen_rands(int reqs) {
    int i, j, alloc, sz, slp;
    double prob;
    char buf[THRD_NMSZ];
    FILE *f;
    struct stat st;

    srand(time(NULL));
    /* create a list of random numbers for each thread */
    for (i = 0; i < NUM_THRDS; i++) {
        /* even lines are allocation sizes,
         * odd lines are sleep times */
        if (stat("tmp/", &st) != 0) {
            if (mkdir("tmp/", MODE) != 0) {
                fprintf(stderr, "mkdir failed in gen_rands()\n");
                return EXIT_FAILURE; 
            }
        }
        /* name the file of random numbers (i) */
        if (snprintf(buf, sizeof(buf), "./tmp/%d.txt", i) == 0) {
            fprintf(stderr, "snprintf failed in gen_rands()\n");
            return EXIT_FAILURE;
        }
        /* open it for writing */
        if((f = fopen(buf, "w")) == NULL) {
            fprintf(stderr, "fopen failed in gen_rands()\n");
            return EXIT_FAILURE;
        }
        /* generate the number of requests passed in */
        for (j = 0; j < reqs; j++) {

            /* allocate or free? */
            alloc = 1;
            prob = unirand();
            if (prob > FREEPROB) {
                alloc = 1;
            }
            else {
                alloc = 0;
            }
            if (fprintf(f, "%d\n", alloc) == 0) {
                fprintf(stderr, "fprintf failed in gen_rands()\n");
                return EXIT_FAILURE;
            }
            /* generate an allocation size */
            sz = (int) normrand(MN_ALLOC, STDDEV_ALLOC);
            if (sz < MIN_ALLOC) {
                sz = MIN_ALLOC;
            }
            if (sz > MAX_ALLOC) {
                sz = MAX_ALLOC;
            }
            if (fprintf(f, "%d\n", sz) == 0) {
                fprintf(stderr, "fprintf failed in gen_rands()\n");
                return EXIT_FAILURE;
            }
            /* generate a sleep time */
            slp = (int) exrand(MN_SLP);
            if (slp < MIN_SLP) {
                slp = MIN_SLP;
            }
            if (slp > MAX_SLP) {
                slp = MAX_SLP;
            }
            if (fprintf(f, "%d\n", slp) == 0) {
                fprintf(stderr, "fprintf failed in gen_rands()\n");
                return EXIT_FAILURE;
            }
        }
        if (fclose(f) != 0) {
            fprintf(stderr, "fclose failed in gen_rands()\n");
            exit(EXIT_FAILURE); 
        }
    }
    return EXIT_SUCCESS;
}

int mainp(int argc, char* argv[]) {
    int alg, rands;

    /* verify args */
    /* argv[1] -> the number of requests to
     * free or allocate for the simulation */
    if (argc < MINARGS || argc > MAXARGS ||
        atoi(argv[1]) < MINREQS || atoi(argv[1]) > MAXREQS) {
        printf("usage: %s <requests>\n", argv[0]);
        exit(EXIT_FAILURE);
    }
    /* (reqs)arg1 = # of requests
     * (alg)arg2 = algorithm
     * (rands)arg3 = generate new random #s */
    reqs = atoi(argv[1]);
    alg = BESTFIT; /* best fit is the default */
    rands = 1; /* yes by default */
    if (argc > 2) {
        alg = atoi(argv[2]);
    }
    if (argc > 3) {
        rands = atoi(argv[3]);
    }
    memAlg = alg;
    /* generates a of random numbers for each thread in the test */
    if (rands && (gen_rands(reqs) != 0)) {
        fprintf(stderr, "gen_rands failed\n");
        exit(EXIT_FAILURE);
    }
    fin = 0;
    /* create threads and run best fit algorithm */
    if (init_thrds(alg) != 0) {
        fprintf(stderr, "init_thrds for Best Fit failed\n");
        exit(EXIT_FAILURE);
    }
    return EXIT_SUCCESS;
}
