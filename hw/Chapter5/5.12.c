/* Reduce memory access */
void psum3(float a[], float p[], long n) {
    long i;
    float val = 0;
    for (i = 0; i < n; i++) {
        val += a[i];
        p[i] = val;
    }
}