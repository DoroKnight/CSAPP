/**
 * Declaration of data type where 4 bytes are packed
 * into an unsigned
 */
typedef unsigned packed_t;

/* Extract byte from word. Return as signed integer */
int xbyte(packed_t word, int bytenum) {
    packed_t exac_byte = (word << ((3 - bytenum) << 3)) >> (3 << 3);
    packed_t sign = exac_byte >> 7;
    return (int)exac_byte - ((int)sign << 8);
}