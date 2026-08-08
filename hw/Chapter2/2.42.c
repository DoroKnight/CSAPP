#include <stdint.h>

int div16(int x) {
    /* Assume the "int" is 32 bits. */
    int bias = (x >> 31) & 0xF;
    return (x + bias) >> 4;
}

/* 
Explain:
    First, consturct the bias: 15(x < 0) or 0(x >= 0)
    bias = (x >> 31) & 0xF: bias = 0 or 15 

    Then, move right 4 bits: return (x + bias) >> 4;

Core:
    construct the bias: (x >> 31) & 0xF
*/