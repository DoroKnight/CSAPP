int int_size_is_32() {
    unsigned int_16 = (unsigned) (-1);
    int_16 >>= 15;
    int_16 >>= 15;
    return (int_16 >>= 1) == 1;
}