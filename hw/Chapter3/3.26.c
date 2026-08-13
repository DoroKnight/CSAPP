long fun_a(unsigned long x) {
    long val = 0;
    while (x != 0) {
        val = val ^ x;
        x >>= 1;
    }
    val = val & 0x1;
    return val;
}
