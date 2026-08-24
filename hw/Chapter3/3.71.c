#include <stdio.h>

void good_echo() {
    char context[8];
    while (fgets(context, 8, stdin)) {
        fputs(context, stdout);
    }
}

int main(void) {
    good_echo();
    return 0;
}