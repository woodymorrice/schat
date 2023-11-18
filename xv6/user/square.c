/* CMPT332 - Group 14
 * Phong Thanh Nguyen (David) - wdz468 - 11310824
 * Woody Morrice - wam553 - 11071060 */

#include "user/square.h"



int square(int n) { 
    if (n == 0) {
        return 0;
    } else {
        return (square(n-1) + n + n-1);
    }
}

