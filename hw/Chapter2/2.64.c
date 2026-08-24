/**
 * Return 1 when any odd bit of x equals 1; 0 otherwise
 * Assume w = 32
 */
int any_odd(unsigned x) {
    return x & 0xAAAAAAAA;
}