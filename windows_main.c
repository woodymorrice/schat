/* Group 14
 * Woody Morrice - wam553 - 11071060 */

#include <Windows.h>
#include <stdio.h>

#include "square.h"

int main() {
    printf(square(4));
    return EXIT_SUCCESS;
}

DWORD WINAPI parent_thread (LPVOID lPtr);

DWORD WINAPI child_thread (LPVOID lPtr);
