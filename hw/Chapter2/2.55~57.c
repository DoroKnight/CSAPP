#include <stdio.h>

typedef unsigned char *byte_pointer;

void show_bytes(byte_pointer start, size_t len) {
    size_t i;
    for (i = 0; i < len; i ++) {
        printf(" %.2x", start[i]);
    }
    printf("\n");
}

void show_int(int x) {
    show_bytes((byte_pointer) &x, sizeof(int));
}

void show_float(float x) {
    show_bytes((byte_pointer) &x, sizeof(float));
}

void show_double(double x) {
    show_bytes((byte_pointer) &x, sizeof(double));
}

void show_long(long x) {
    show_bytes((byte_pointer) &x, sizeof(long));
}

void show_pointer(void* x) {
    show_bytes((byte_pointer) &x, sizeof(void *));
}

void show_short(short x) {
    show_bytes((byte_pointer) &x, sizeof(short));
}

int main(void) {
    int x = 0;
    short s = 24;
    float y = 3.14;
    double m = 3.1415926;
    long n = 114514;
    int *p = &x;

    show_int(x);
    show_short(s);
    show_float(y);
    show_double(m);
    show_long(n);
    show_pointer(p);

    return 0;
}