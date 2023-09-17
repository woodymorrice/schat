#include <stdio.h>
#include <stdlib.h>

#include "list.h"



int main(int argc, char* argv[]) {


if (argc != 2) {
    perror("Usage: perror. wrong number of arguments");
    return -1;
}

int test = atoi(argv[1]);

return EXIT_SUCCESS;
}
