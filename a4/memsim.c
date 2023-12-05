/* CMPT332 - Group 14
 * Phong Thanh Nguyen (David) - wdz468 - 11310824
 * Woody Morrice - wam553 - 11071060 */

/* All the list source code files on the behalf of:
 * Joseph Medernach, imy309, 11313955
 * John Miller, knp254, 11323966
 */
#include <stdio.h>
#include <stdlib.h>
#include <rtthreads.h>
#include <RttCommon.h>

#include <list.h>
#include <random.h>


#define MINARGS 2
#define MAXARGS 2
#define MINREQS 1
#define MAXREQS 1000
#define NUM_THRDS 1
#define THRD_NMSZ 32
#define MIN_ALLOC 1
#define MAX_ALLOC 2048
#define MIN_SLP 1 /* this CANNOT be 0 */
#define MAX_SLP 5
#define STKSIZE 65539
#define BESTFIT 0
#define FIRSTFIT 1
#define NTHRDARGS 2
#define INTCHRS 4

/* NOTE: MIN_SLP can't be one because if it's 0 on the last line of
 * the generated random number file, atoi() will fail on that line.
 * Don't ask me why. */

static int reqs;

void sim_proc(void* num) {
    int* args;
    char procnum[THRD_NMSZ], line[INTCHRS+1];
    FILE* f;
    int i, readnum;

    /* args[0] = algorithm, args[1] = proc number */
    args = (int*)num;
    
    /* get the name of the random # input file */
    if (snprintf(procnum, sizeof(procnum), "%d.txt", args[1]) == 0) {
        fprintf(stderr, "snprintf failed in sim_proc()\n");
        exit(EXIT_FAILURE);
    }

    /* open its generated random nums */
    if((f = fopen(procnum, "r")) == NULL) {
        fprintf(stderr, "fopen failed in sim_proc()\n");
        exit(EXIT_FAILURE);
    }

    /* iterate through the random numbers */
    for (i = 0; i < reqs*2; i++) {
        /* read a line from the file */
        if (fgets(line, sizeof(line), f) == NULL) {
            fprintf(stderr, "fgets failed in sim_proc()\n");
            exit(EXIT_FAILURE);  
        }
        /* convert that line to an int */
        if ((readnum = atoi(line)) == 0) {
            fprintf(stderr, "atoi failed in sim_proc()\n");
            exit(EXIT_FAILURE);
        }

        /* test print */
        printf("%d\n", readnum);
    }

    free(args); /*cant check return value :( */
    if (fclose(f) != 0) {
        fprintf(stderr, "fclose failed in sim_proc()\n");
        exit(EXIT_FAILURE); 
    }
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
    return EXIT_SUCCESS;

}

int gen_rands(int reqs) {
    int i, j, alloc, slp;
    char buf[THRD_NMSZ];
    FILE *f;
    /* create a list of random numbers for each thread */
    for (i = 0; i < NUM_THRDS; i++) {
        /* even lines are allocation sizes,
         * odd lines are sleep times */

        /* name the file of random numbers (i) */
        if (snprintf(buf, sizeof(buf), "%d.txt", i) == 0) {
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
            /* generate an allocation size */
            alloc = (int) normrand(MN_ALLOC, STDDEV_ALLOC);
            if (alloc < MIN_ALLOC) {
                alloc = MIN_ALLOC;
            }
            if (alloc > MAX_ALLOC) {
                alloc = MAX_ALLOC;
            }
            if (fprintf(f, "%d\n", alloc) == 0) {
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

/* mainp - 
 * */
int mainp(int argc, char* argv[]) {
    /*int i;*/

    /* verify args */
    /* argv[1] -> the number of requests to
     * free or allocate for the simulation */
    if (argc < MINARGS || argc > MAXARGS ||
        atoi(argv[1]) < MINREQS || atoi(argv[1]) > MAXREQS) {
        printf("usage: %s <requests>\n", argv[0]);
        exit(EXIT_FAILURE);
    }

    reqs = atoi(argv[1]);


    /* testing args */
    /*printf("%d\n", argc);
    for (i = 0; i < argc; i++) {
        printf("%s\n", argv[i]);
    }*/

    /* generates a of random numbers for each thread in the test */
    if (gen_rands(atoi(argv[1])) != 0) {
        fprintf(stderr, "gen_rands failed\n");
        exit(EXIT_FAILURE);
    }

    /* create threads and run best fit algorithm */
    if (init_thrds(BESTFIT) != 0) {
        fprintf(stderr, "init_thrds for Best Fit failed\n");
        exit(EXIT_FAILURE);
    }

    /* create threads and run first fit algorithm */
    if (init_thrds(FIRSTFIT) != 0) {
        fprintf(stderr, "init_thrds for First Fit failed\n");
        exit(EXIT_FAILURE);
    }

    return EXIT_SUCCESS;
}
