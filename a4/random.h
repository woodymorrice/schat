/* CMPT332 - Group 14
 * Phong Thanh Nguyen (David) - wdz468 - 11310824
 * Woody Morrice - wam553 - 11071060 */
#include <math.h>
#include <stdlib.h>

/* Important Test Variables */
#define NUM_THRDS 5
#define MIN_ALLOC 1
#define MAX_ALLOC 65536
#define MIN_SLP 1 /* this CANNOT be 0 */
#define MAX_SLP 30
#define FREEPROB 0.50
#define MN_SLP 10 /* avg sleep time */
#define MN_ALLOC 4096 /* avg allocation size */
#define STDDEV_ALLOC 1024/* std. deviation */

/* NOTE: MIN_SLP can't be one because if it's 0 on the last line of
 * the generated random number file, atoi() will fail on that line.
 * ** Actually the reason it can't be 0 is because atoi() returns 0
 * if it can't convert to an integer, so there is no way to differentiate
 * between an error in conversion and the value being converted simply
 * being a 0 */
double unirand();
double exrand(int);
double normrand(int, int);
