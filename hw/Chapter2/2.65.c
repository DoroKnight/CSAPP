/**
 * Return 1 when x contains an odd number of 1s; 0 otherwise.
 * Assume w = 32
 */
int odd_ones(unsigned x) {
    x ^= x >> 16;
    x ^= x >> 8;
    x ^= x >> 4;
    x ^= x >> 2;
    x ^= x >> 1;
    return x & 1;
}

/**
 * 解析：
 * 核心算法：奇偶校验（ parity ）
 * 一位一位按位异或，奇数个 1 就是 1，偶数个 1 就是 0
 * 本题技巧：折叠 XOR
 * 对上半部分和下半部分按位异或，可以保留最后的奇偶性
 * 核心的思想：在一个机器字内部进行并行的“分治合并”，每一步都把处理范围扩大一倍
 */