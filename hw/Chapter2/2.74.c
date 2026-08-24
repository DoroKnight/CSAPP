/**
 * Determine whether arguments can be subtracted without overflow.
 */
int tsub_ok(int x, int y) {
    int w = sizeof(int) << 3;

    /* Transform y to -y, then the - convert to + */
    unsigned ux = (unsigned) x;
    unsigned u_newy = (unsigned) -y;
    int sum = (int) (ux + u_newy);

    int sx = x >> (w - 1);
    int sy = -y >> (w - 1);
    int ss = sum >> (w - 1);

    /* x and -y are positive, but sum is negative: positive overflow. */
    int pos_overflow = ~sx & ~sy & ss;

    /* x and -y are negative, but sum is positive: negative overflow. */
    int neg_overflow = sx & sy & ~ss;

    return !((pos_overflow | neg_overflow) == 0);
}