long cread_alt(long *xp) {
    long zero = 0;
    return *(xp ? xp : &zero);
}