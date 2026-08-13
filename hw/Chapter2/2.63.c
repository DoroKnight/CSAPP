unsigned srl(unsigned x, int k) {
    /* Perform shift arithmetically */
    unsigned xsra = (int) x >> k;
    unsigned mask = -1 << (sizeof(int) * 8 - k);
    unsigned diff = mask & xsra;
    return xsra - diff;
}

unsigned sra(int x, int k) {
    /* Perform shift logically*/
    int xsrl = (unsigned) x >> k;
    int sign_mask = 1 << (sizeof(int) * 8 - 1);
    int sign = (x & sign_mask) != 0;
    int mask = -1 << (sizeof(int) * 8 - k);
    return xsrl | (mask & -sign);
}