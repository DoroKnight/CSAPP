typedef enum {NEG, ZERO, POS, OTHER} range_t;

range_t find_range(float x) {
    range_t result;
    __asm__ (
        "vxorps %%xmm1, %%xmm1, %%xmm1\n\t"     /* Set 0 */
        "vucomiss %%xmm1, %[x]\n\t"                /* Compare x : 0 */

        "movq $3, %%rdx\n\t"            /* Set OTHER */
        "cmovp %%rdx, %[result]\n\t"       /* NaN */
        "decq %%rdx\n\t"                /* Set POS */
        "cmovg %%rdx, %[result]\n\t"       /* Positive */
        "decq %%rdx\n\t"                /* Set ZERO */
        "cmove %%rdx, %[result]\n\t"          /* ZERO */
        "decq %%rdx\n\t"                /* Set NEG*/
        "cmovl %%rdx, %[result]\n\t"          /* Negative */

        : [result] "=a" (result)
        : [x] "x" (x)
        : "xmm1", "rdx", "cc"
    );

    return result;
}