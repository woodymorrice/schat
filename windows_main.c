/* Group 14
 * Woody Morrice - wam553 - 11071060 */

#include <Windows.h>
#include <stdio.h>
#include <stdlib.h>

#include "square.h"

int main(int argc, char* argv[]) {

    int i; /* counting variable for for loop */

    printf("Number of arguments: %d\n", argc);
    for (i = 0; i < argc; i++) {
        printf("%s\n", argv[i]);
    }
    
    return EXIT_SUCCESS;
}

DWORD WINAPI parentThread(LPVOID lPtr);

DWORD WINAPI childThread(LPVOID lPtr);
