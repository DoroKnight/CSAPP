/* 
 * CS:APP Data Lab 
 * 
 * <Please put your name and userid here>
 * 
 * bits.c - Source file with your solutions to the Lab.
 *          This is the file you will hand in to your instructor.
 *
 * WARNING: Do not include the <stdio.h> header; it confuses the dlc
 * compiler. You can still use printf for debugging without including
 * <stdio.h>, although you might get a compiler warning. In general,
 * it's not good practice to ignore compiler warnings, but in this
 * case it's OK.  
 */

#if 0
/*
 * Instructions to Students:
 *
 * STEP 1: Read the following instructions carefully.
 */

You will provide your solution to the Data Lab by
editing the collection of functions in this source file.

INTEGER CODING RULES:
 
  Replace the "return" statement in each function with one
  or more lines of C code that implements the function. Your code 
  must conform to the following style:
 
  int Funct(arg1, arg2, ...) {
      /* brief description of how your implementation works */
      int var1 = Expr1;
      ...
      int varM = ExprM;

      varJ = ExprJ;
      ...
      varN = ExprN;
      return ExprR;
  }

  Each "Expr" is an expression using ONLY the following:
  1. Integer constants 0 through 255 (0xFF), inclusive. You are
      not allowed to use big constants such as 0xffffffff.
  2. Function arguments and local variables (no global variables).
  3. Unary integer operations ! ~
  4. Binary integer operations & ^ | + << >>
    
  Some of the problems restrict the set of allowed operators even further.
  Each "Expr" may consist of multiple operators. You are not restricted to
  one operator per line.

  You are expressly forbidden to:
  1. Use any control constructs such as if, do, while, for, switch, etc.
  2. Define or use any macros.
  3. Define any additional functions in this file.
  4. Call any functions.
  5. Use any other operations, such as &&, ||, -, or ?:
  6. Use any form of casting.
  7. Use any data type other than int.  This implies that you
     cannot use arrays, structs, or unions.

 
  You may assume that your machine:
  1. Uses 2s complement, 32-bit representations of integers.
  2. Performs right shifts arithmetically.
  3. Has unpredictable behavior when shifting if the shift amount
     is less than 0 or greater than 31.


EXAMPLES OF ACCEPTABLE CODING STYLE:
  /*
   * pow2plus1 - returns 2^x + 1, where 0 <= x <= 31
   */
  int pow2plus1(int x) {
     /* exploit ability of shifts to compute powers of 2 */
     return (1 << x) + 1;
  }

  /*
   * pow2plus4 - returns 2^x + 4, where 0 <= x <= 31
   */
  int pow2plus4(int x) {
     /* exploit ability of shifts to compute powers of 2 */
     int result = (1 << x);
     result += 4;
     return result;
  }

FLOATING POINT CODING RULES

For the problems that require you to implement floating-point operations,
the coding rules are less strict.  You are allowed to use looping and
conditional control.  You are allowed to use both ints and unsigneds.
You can use arbitrary integer and unsigned constants. You can use any arithmetic,
logical, or comparison operations on int or unsigned data.

You are expressly forbidden to:
  1. Define or use any macros.
  2. Define any additional functions in this file.
  3. Call any functions.
  4. Use any form of casting.
  5. Use any data type other than int or unsigned.  This means that you
     cannot use arrays, structs, or unions.
  6. Use any floating point data types, operations, or constants.


NOTES:
  1. Use the dlc (data lab checker) compiler (described in the handout) to 
     check the legality of your solutions.
  2. Each function has a maximum number of operations (integer, logical,
     or comparison) that you are allowed to use for your implementation
     of the function.  The max operator count is checked by dlc.
     Note that assignment ('=') is not counted; you may use as many of
     these as you want without penalty.
  3. Use the btest test harness to check your functions for correctness.
  4. Use the BDD checker to formally verify your functions
  5. The maximum number of ops for each function is given in the
     header comment for each function. If there are any inconsistencies 
     between the maximum ops in the writeup and in this file, consider
     this file the authoritative source.

/*
 * STEP 2: Modify the following functions according the coding rules.
 * 
 *   IMPORTANT. TO AVOID GRADING SURPRISES:
 *   1. Use the dlc compiler to check that your solutions conform
 *      to the coding rules.
 *   2. Use the BDD checker to formally verify that your solutions produce 
 *      the correct answers.
 */


#endif
//1
/* 
 * bitXor - x^y using only ~ and & 
 *   Example: bitXor(4, 5) = 1
 *   Legal ops: ~ &
 *   Max ops: 14
 *   Rating: 1
 */
int bitXor(int x, int y) {
    // Use De Morgan's laws to convert the OR operation
    return ~(~(x & ~y) & ~(~x & y));      
}
/* 
 * tmin - return minimum two's complement integer 
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 4
 *   Rating: 1
 */
int tmin(void) {
    // 000...0 -> 111...1 -> 100...0
    return (~0) << 31;        
}
//2
/*
 * isTmax - returns 1 if x is the maximum, two's complement number,
 *     and 0 otherwise 
 *   Legal ops: ! ~ & ^ | +
 *   Max ops: 10
 *   Rating: 1
 */
int isTmax(int x) {
    // exclude -1: !!(~x)
    return !(~x ^ (x + 1)) & !!(~x);
}
/* 
 * allOddBits - return 1 if all odd-numbered bits in word set to 1
 *   where bits are numbered from 0 (least significant) to 31 (most significant)
 *   Examples allOddBits(0xFFFFFFFD) = 0, allOddBits(0xAAAAAAAA) = 1
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 12
 *   Rating: 2
 */
int allOddBits(int x) {
    x = x & (x >> 16);
    x = x & (x >> 8);
    x = x & (x >> 4);
    x = x & (x >> 2);
    return x >> 1 & 0x1;
}
/* 
 * negate - return -x 
 *   Example: negate(1) = -1.
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 5
 *   Rating: 2
 */
int negate(int x) {
    // The conception of 2s complement
    return ~x + 1;
}
//3
/* 
 * isAsciiDigit - return 1 if 0x30 <= x <= 0x39 (ASCII codes for characters '0' to '9')
 *   Example: isAsciiDigit(0x35) = 1.
 *            isAsciiDigit(0x3a) = 0.
 *            isAsciiDigit(0x05) = 0.
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 15
 *   Rating: 3
 */
int isAsciiDigit(int x) {
    int signX = x >> 31;
    int NegMin = ~(0x30) + 1;    // -0x30
    int NegX = ~x + 1;    // -x
    int flag1 = (x + NegMin) >> 31;      // Whether x >= 0x30
    int flag2 = (0x39 + NegX) >> 31;      // Whether x <= 0x39
    return ~signX & ~flag1 & ~flag2 & 0x1;
}
/* 
 * conditional - same as x ? y : z 
 *   Example: conditional(2,4,5) = 4
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 16
 *   Rating: 3
 */
int conditional(int x, int y, int z) {
    // Declare the variable first.
    int flag;

    // First， determine whether x is 0.
    x = x | (x << 16);
    x = x | (x << 8);
    x = x | (x << 4);
    x = x | (x << 2);
    x = x | (x << 1);   // If x != 0, the MSB is 1, otherwise 0

    flag = x >> 31; // If x != 0, the flag is 0xFFFF, otherwise 0

    // If the x == 0, y & flag = 0 and z & flag = z
    // Otherwise, y & flag = y and z & flag = 0
    return (y & flag) + (z & ~flag);
}
/* 
 * isLessOrEqual - if x <= y  then return 1, else return 0 
 *   Example: isLessOrEqual(4,5) = 1.
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 24
 *   Rating: 3
 */
int isLessOrEqual(int x, int y) {
    // If x < 0 and y >= 0, return 1
    // If x >= 0 and y < 0, return 0;
    int Xsign = x >> 31;
    int Ysign = y >> 31;
    int signXor = (~Xsign & Ysign) | (~Ysign & Xsign);

    // If x >= 0 and y >= 0, (y-x >= 0) => return 1
    int Neg_X = ~x + 1;
    int sign = (y + Neg_X) >> 31;
    int LOE = ~signXor & ~sign;

    // If x < 0 and y < 0:
    // if x = INT_MIN: return 1
    int IsIntMin = Xsign & (x & (~x + 1) >> 31);
    // if x != INT_MIN, same as the case2

    return (IsIntMin | (signXor & Xsign) | LOE) & 0x1;
}
//4
/* 
 * logicalNeg - implement the ! operator, using all of 
 *              the legal operators except !
 *   Examples: logicalNeg(3) = 0, logicalNeg(0) = 1
 *   Legal ops: ~ & ^ | + << >>
 *   Max ops: 12
 *   Rating: 4 
 */
int logicalNeg(int x) {
    // If x != 0, there exists at least one 1.
    x = x | (x >> 16);
    x = x | (x >> 8);
    x = x | (x >> 4);
    x = x | (x >> 2);
    x = x | (x >> 1);

    // If the x != 0, the LSB will be 1.
    return ~x & 0x1;
}
/* howManyBits - return the minimum number of bits required to represent x in
 *             two's complement
 *  Examples: howManyBits(12) = 5
 *            howManyBits(298) = 10
 *            howManyBits(-5) = 4
 *            howManyBits(0)  = 1
 *            howManyBits(-1) = 1
 *            howManyBits(0x80000000) = 32
 *  Legal ops: ! ~ & ^ | + << >>
 *  Max ops: 90
 *  Rating: 4
 */
int howManyBits(int x) {
    int sign = x >> 31;
    int b16, b8, b4, b2, b1, b0;

    /* 正数保持不变，负数按位取反 */
    x = x ^ sign;

    /* 二分查找最高有效位 */
    b16 = !!(x >> 16) << 4;
    x = x >> b16;

    b8 = !!(x >> 8) << 3;
    x = x >> b8;

    b4 = !!(x >> 4) << 2;
    x = x >> b4;

    b2 = !!(x >> 2) << 1;
    x = x >> b2;

    b1 = !!(x >> 1);
    x = x >> b1;

    b0 = x;

    /* 最高有效位位置，加上符号位 */
    return b16 + b8 + b4 + b2 + b1 + b0 + 1;
}
//float
/* 
 * floatScale2 - Return bit-level equivalent of expression 2*f for
 *   floating point argument f.
 *   Both the argument and result are passed as unsigned int's, but
 *   they are to be interpreted as the bit-level representation of
 *   single-precision floating point values.
 *   When argument is NaN, return argument
 *   Legal ops: Any integer/unsigned operations incl. ||, &&. also if, while
 *   Max ops: 30
 *   Rating: 4
 */
unsigned floatScale2(unsigned uf) {
    // Declare the variable first.
    unsigned sign = uf >> 31;
    unsigned exponent = uf >> 23 & 0xFF;
    unsigned significand = uf << 9 >> 9;
    unsigned MSBofSignificand;
    unsigned mask;
    unsigned result;

    // uf is NaN.
    if (exponent == 0xFF && significand != 0) return uf;

    // uf is +INF or -INF:
    if (exponent == 0xFF) return uf;

    // uf is denormalized.
    if (exponent == 0) {
        MSBofSignificand = significand >> 22;
        if (MSBofSignificand != 0) {
            exponent += 1;
        }
        mask = -1;
        significand = significand << 1 & (mask >> 9);
    } else {
        // uf is normalized.
        exponent += 1;
        if (exponent == 0xFF) return (0xFF << 23) + (sign << 31);
    }

    result = (sign << 31) + (exponent << 23) + significand;
    return result;
}
/* 
 * floatFloat2Int - Return bit-level equivalent of expression (int) f
 *   for floating point argument f.
 *   Argument is passed as unsigned int, but
 *   it is to be interpreted as the bit-level representation of a
 *   single-precision floating point value.
 *   Anything out of range (including NaN and infinity) should return
 *   0x80000000u.
 *   Legal ops: Any integer/unsigned operations incl. ||, &&. also if, while
 *   Max ops: 30
 *   Rating: 4
 */
int floatFloat2Int(unsigned uf) {
    unsigned sign = uf >> 31;
    unsigned exponent = uf >> 23 & 0xFF;
    unsigned significand = uf << 9 >> 9;
    unsigned extra_one, M, Bias, E;
    int offset, result;

    // If uf is NaN or infinity, return 0x80000000u
    if (exponent == 0xff) return 0x1 << 31;

    // If uf is denormalized, directly return 0
    // Because the biggest denormalized float is also too small.
    if (exponent == 0) return 0;

    // uf is normalized.
    // First, get the correct format of significand
    extra_one = 0x1 << 23;
    M = extra_one + significand;
    Bias = 0x7F;
    if (exponent < Bias) return 0;      // Too small

    E = exponent - Bias;
    if (E > 31)     return 0x1 << 31;

    offset = 23 - E;
    if (offset < 0) result = M << -offset;
    else result = M >> offset;

    if (sign != 0) result = -result;
    return result;
}
/* 
 * floatPower2 - Return bit-level equivalent of the expression 2.0^x
 *   (2.0 raised to the power x) for any 32-bit integer x.
 *
 *   The unsigned value that is returned should have the identical bit
 *   representation as the single-precision floating-point number 2.0^x.
 *   If the result is too small to be represented as a denorm, return
 *   0. If too large, return +INF.
 * 
 *   Legal ops: Any integer/unsigned operations incl. ||, &&. Also if, while 
 *   Max ops: 30 
 *   Rating: 4
 */
unsigned floatPower2(int x) {
    int Bias = 0x7F;
    unsigned pos_INF = 0xFF << 23;

    int minExp = 1 - Bias;
    int maxExp = 0xFE;
    int exponent;

    // Too small to be represented as a denorm, return 0
    if (x < 0 && x < minExp) return 0;

    // Too large, return +INF
    if (x > maxExp - Bias) return pos_INF;

    // if x is denormalized:
    if (x >= minExp && x < minExp + 23) {
        return 0x1 << (x - minExp);
    } else {
        // if x is normalized:
        exponent = x + Bias;
        return exponent << 23;
    }
}
