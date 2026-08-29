/**
 * Write the C code then transform to y86
 */
long rsum(long *start, long count) {
    if (count <= 0) return 0;
    return *start + rsum(start + 1, count - 1);
}