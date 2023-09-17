/* Group 14 - CMPT 332
 * Woody Morrice - wam553 - 11071060 */

#include <stdio.h>
#include <stdlib.h>

#include "square.h"

int square(int n) {

    if (n < 0) {
        printf("Error in procedure square(): invalid parameter n\n");
        return EXIT_FAILURE;
    } else {
        printf("Got to procedure square()\n");
    }

    if (n == 0) {
        return 0;
    } else {
        return (square(n-1) + n + n-1);
    }

}
