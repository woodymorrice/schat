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


#define MINARGS 2
#define MAXARGS 2
#define MINREQS 1
#define MAXREQS 65536


/* mainp - 
 * */
int mainp(int argc, char* argv[]) {
    int i;

    /* check args */
    /* argv[1] -> the number of requests to
     * free or allocate for the simulation */
    if (argc < MINARGS || argc > MAXARGS ||
        atoi(argv[1]) < MINREQS || atoi(argv[1]) > MINREQS) {
        printf("usage: %s <requests>\n", argv[0]);
        exit(EXIT_FAILURE);
    }

    /* testing args */
    printf("%d\n", argc);
    for (i = 0; i < argc; i++) {
        printf("%s\n", argv[i]);
    }




    return EXIT_SUCCESS;
}
