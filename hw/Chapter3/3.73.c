typedef enum {NEG, ZERO, POS, OTHER} range_t;

range_t find_range(float x) {
    range_t result;

    __asm__ volatile (
        "vxorps %%xmm1, %%xmm1, %%xmm1\n\t"     /* xmm1 = 0 */
        "vucomiss %%xmm1, %[x]\n\t"              /* Compare x : 0 */

        "jp 1f\n\t"     /* NaN */
        "jb 2f\n\t"     /* x < 0 */
        "je 3f\n\t"     /* x = 0 */

        /* Positive */
        "movl $2, %[result]\n\t"     /* Set POS */
        "jmp 4f\n\t"                /* Over */

        /* NaN */
        "1:\n\t"
        "movl $3, %[result]\n\t"    /* OTHER */
        "jmp 4f\n\t"                /* Over */

        /* NEG */
        "2:\n\t"
        "movl $0, %[result]\n\t"     /* Set NEG */
        "jmp 4f\n\t"                /* Over */

        /* ZERO */
        "3:\n\t"
        "movl $1, %[result]\n\t"     /* Set ZERO */
        "jmp 4f\n\t"                /* Over */

        "4:\n\t"
        : [result] "=a" (result)
        : [x] "x" (x)
        : "xmm1", "cc"
    );

    return result;
}