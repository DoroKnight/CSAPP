/**
 * Mask with least signficant n bits set to 1.
 * Example: n = 6 --> 0x3F, n = 17 --> 0x1FFFF
 * Assume 1 <= n <= w
 */
int lower_one_mask(int n) {
    // If n = x (x < w) 
    return -1 >> (sizeof(int) << 3 - n);
}