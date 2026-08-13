long_fact_for_gd_goto(long n) {
    long result = 1;
    long i = 2;
    if (i > n)
        goto done;
loop:  
    result *= i;
    i += 1;
    if (i <= n)
        goto loop;
done:
    return result;
}