double funct3(int *ap, double b, long c, float *dp) {
    return ((b > *ap) ? (*dp * c) : (2 * (*dp) + c));
}

// Standard Anwser:
double funct3_ans(int *ap, double b, long c, float *dp) {
    int a = *ap;
    float d = *dp;
    if (b > a) 
        return c * d;
    else 
        return c + 2 * d;
}