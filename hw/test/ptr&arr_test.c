#include <stdio.h>

int main(void) {
    int A[10] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9};
    printf("%d, %d", A[2], *(A + 2));
    return 0;
}
