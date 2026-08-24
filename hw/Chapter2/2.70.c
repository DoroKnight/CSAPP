/**
 * Return 1 when x can be represented as an n-bit, 2's-complement
 * number; 0 otherwise
 * Assume 1 <= n <= w
 */
int fits_bits(int x, int n) {
    int min = -1 << (n - 1);
    int max = 1 << (n - 1) - 1;
    return min <= x && x <= max;
}