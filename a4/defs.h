/* CMPT332 - Group 14
 * Phong Thanh Nguyen (David) - wdz468 - 11310824
 * Woody Morrice - wam553 - 11071060 */

/* Important Test Variables */
#define NUM_THRDS 8
#define MIN_ALLOC 1
#define MAX_ALLOC 64
#define MIN_SLP 1 /* this CANNOT be 0 */
#define MAX_SLP 30
#define FREEPROB 0.5
#define MN_SLP 10 /* avg sleep time */
#define MN_ALLOC 1 /* avg allocation size */
#define STDDEV_ALLOC 1/* std. deviation */

/* NOTE: MIN_SLP can't be one because if it's 0 on the last line of
 * the generated random number file, atoi() will fail on that line.
 * ** Actually the reason it can't be 0 is because atoi() returns 0
 * if it can't convert to an integer, so there is no way to differentiate
 * between an error in conversion and the value being converted simply
 * being a 0 */

/* terminal arguments to memsim */
#define MINARGS 2
#define MAXARGS 5

/* requests for memsim */
#define MINREQS 1
#define MAXREQS 10000
#define NRAND 3 /* # of random #'s to generate per request */

/* thread info */
#define THRD_NMSZ 32 /* name size */
#define STKSIZE 65539 /* stack size */
#define NTHRDARGS 2 /* # of arguments passed to threads */

/* algorithm identifiers */
#define BESTFIT 0
#define FIRSTFIT 1

/* miscellaneous */
#define INTCHRS 4
#define MODE 0755 /* mode for creating directories */
#define BUF_SIZE 128 /* character buffer size */

/* defines for random.c */
#define SLPMEAN 10
#define SLPSTDDEV 3
