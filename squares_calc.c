#include <stdio.h>
#include <stdlib.h>

int calc(int n);

int main (int argc, char* argv[]) {
    int n;
    n = atoi(argv[1]);
    printf("%d\n", calc(n));
    return EXIT_SUCCESS;
}

int calc(int n) {
    if (n==0) {
        return 1;
    } else {
        return (n+1) + calc(n-1);
    }
}

