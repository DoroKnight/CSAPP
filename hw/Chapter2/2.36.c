#include <stdint.h>

/* Determine whether arguments can be multiplied without overflow */
int tmul_ok(int x, int y) {
    /* WARNING: traverse int to int64_t first */
    int64_t res = (int64_t)x * y;
    /* Whether can res traverse back to int. y: Not overflow, n: overflow*/
    return res == (int)res;
}