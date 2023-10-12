/* CMPT332 - Group 14
 * Phong Thanh Nguyen (David) - wdz468 - 11310824
 * Woody Morrice - wam553 - 11071060 */


#include <rtthreads.h>
#include <RttCommon.h>

int MonInit(int numConds) {
    if (numConds < 1) {
        return -1;
    }

    return 0;
}

int MonEnter() {

    return 0;
}


int MonLeave() {

    return 0;
}


int MonWait(int CV) {
    if (CV < 0) {
        return -1;
    }

    return 0;
}


int MonSignal(int CV) {
    if (CV < 0) {
        return -1;
    }

    return 0;
}

