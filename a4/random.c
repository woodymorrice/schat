/* CMPT332 - Group 14
 * Phong Thanh Nguyen (David) - wdz468 - 11310824
 * Woody Morrice - wam553 - 11071060 */

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>

#define MEAN 10
#define STDDEV 3

double exrand(int randi) {
    double x;
    x = (double)randi/(double)RAND_MAX;
    return (-MEAN*log(x));
}

double normrand(int randi) {
    double u1, u2, x, u3;
    do {
        u1 = (double)randi/(double)RAND_MAX;
        u2 = (double)rand()/(double)RAND_MAX;
        x = -(log(u1)); 
    } while (u2 > pow(M_E, -(x-1)*(x-1)/2));
    u3 = (double)rand()/(double)RAND_MAX;
    if (u3 > 0.5) {
        return MEAN+STDDEV*x;
    }
    else {
        return MEAN-STDDEV*x;
    }

}


int main() {
    int i;
    double x;
    int randi;
    for (i=0;i<10;i++){
        randi = rand();
        x = (double)randi/(double)RAND_MAX*(double)20 + 1;
        printf("rand(): %d\n", (int)x);
        printf("exrand(): %d\n", (int)exrand(randi) + 1);
        printf("normrand(): %d\n", (int)normrand(randi) + 1);
    }
    return 0;
}
