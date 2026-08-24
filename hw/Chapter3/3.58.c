long decode2(long x, long y, long z) {
    long temp = y - z;
    long result = x * temp;
    long mask = temp << 63 >> 63;
    return result ^ mask;
}

/**
 * More strict anwser:
 */
long decode2_ans(long x, long y, long z) {
    long temp = y - z;
    long mask = -(temp & 1);
    return x * temp ^ mask;
}