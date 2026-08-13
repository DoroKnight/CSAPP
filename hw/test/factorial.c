#include <stdio.h>
#include <limits.h>

int main(void) {
    int fact1 = 1;
    long fact2 = 2;

    int time1 = 0, time2 = 0;

    while (fact1 < INT_MAX / (time1 + 1)) {
        fact1 *= (time1 + 1);
        time1 += 1;
    }

    while (fact2 < LONG_MAX / (time2 + 1)) {
        fact2 *= (time2 + 1);
        time2 += 1;
    }

    printf("%d, %d\n", time1, time2);
    return 0;
}