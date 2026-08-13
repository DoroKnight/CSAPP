#include <stdio.h>

int main(void) {
    printf("%d, %d, %d, %d, %d\n", sizeof(int), sizeof(long),
                                   sizeof(char *), sizeof(short),
                                   sizeof(void *));
}   