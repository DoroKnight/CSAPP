int int_size_is_32() {
    unsigned int_32 = (unsigned) (-1);
    int_32 >>= 31;
    return int_32 == 1;
}