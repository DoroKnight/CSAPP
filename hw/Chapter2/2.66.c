/**
 * Generate mask indicating leftmost 1 in x. Assume w = 32
 * For example, 0xFF00 -> 0x8000, and 0x6600 -->0x4000.
 * If x = 0, then return 0.
 * 
 * Tips: Convert x to vector like [0...011...1]
 */
int leftmost_one(unsigned x) {
    x |= x >> 1;
    x |= x >> 2;
    x |= x >> 4;
    x |= x >> 8;
    x |= x >> 16;

    return x & ~(x >> 1);
}

/**
 * 解析：
 * 根据题目中的 Tips，向右扩展 1：使用 OR 来扩展最高位，然后利用错位比较来提取边界
 * 核心的思想：在一个机器字内部进行并行的“分治合并”，每一步都把处理范围扩大一倍
 */
