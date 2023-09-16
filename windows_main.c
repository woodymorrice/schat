/* Group 14
 * Woody Morrice - wam553 - 11071060 */

#include <Windows.h>
#include <stdio.h>

int main() {
    printf("Success!");
    return EXIT_SUCCESS;
}

DWORD WINAPI parent_thread (LPVOID lPtr);

DWORD WINAPI child_thread (LPVOID lPtr);
