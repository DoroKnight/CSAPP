/**
 * Addition that saturates to TMin or TMax.
 */
#include <limits.h>

int saturating_add(int x, int y) {
    int w = sizeof(int) << 3;

    /* Using addition of unsigned, aviod undefined behaviors like overflow. */
    unsigned ux = (unsigned) x;
    unsigned uy = (unsigned) y;
    int sum = (int) (ux + uy);

    /**
     * Algrithem move right:
     * unsigned: 0x00000000
     * signed:   0xFFFFFFFF
     */
    int sx = x >> (w - 1);
    int sy = y >> (w - 1);
    int ss = sum >> (w - 1);

    /* x and y are unsigned, but sum is negative: Positive Overflow */
    int pos_overflow = ~sx & ~sy & ss;

    /* x and y are negative, but sum is positive: Negative Overflow */
    int neg_overflow = sx & sy & ~ss;

    /* No overflow */
    int normal = ~(pos_overflow | neg_overflow);

    return (normal       & sum)      |
           (pos_overflow & INT_MAX)  |
           (neg_overflow & INT_MIN);
}