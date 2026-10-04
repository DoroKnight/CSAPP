/**
 * Improve the performance of merge function
 */
void impro_merge(long src1[], long src2[], long dest[], long n) {
    long i1 = 0, i2 = 0, id = 0;
    while (i1 < n && i2 < n) {
        long v1 = src1[i1];
        long v2 = src2[i2];
        long take = v1 < v2;
        dest[id++] = take ? v1 : v2;
        i1 += take;
        i2 += !take;
    }
    while (i1 < n)  dest[id++] = src1[i1++];
    while (i2 < n)  dest[id++] = src2[i2++];
}

void merge(long src1[], long src2[], long dest[], long n) {
    long i1 = 0, i2 = 0, id = 0;
    while (i1 < n && i2 < n) {
        if (src1[i1] < src2[i2]) dest[id++] = src1[i1++];
        else dest[id++] = src2[i2++]; 
    }
    while (i1 < n)  dest[id++] = src1[i1++];
    while (i2 < n)  dest[id++] = src2[i2++];
}