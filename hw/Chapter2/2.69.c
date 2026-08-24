/**
 * Do rotating left shift. Assume 0 <= n < w
 * Example when x = 0x12345678 and w = 32:
 *     n = 4 -> 0
 */
unsigned rotate_left(unsigned x, int n) {
    unsigned abst_mask = (unsigned)(-1) << (31 - n);
    abst_mask <<= 1;
    unsigned part1 = (x & abst_mask) >> n;
    unsigned part2 = x << n;
    return part2 + part1;
}