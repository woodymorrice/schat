/* Group 14 - CMPT 332
 * Woody Morrice - wam553 - 11071060 */

#include "square.h"

int square(int n) {
    if (n == 0) {
        return 0;
    } else {
        return (square(n-1) + n + n-1);
    }
}
