/*  Standard anwser:
    Take advantage of the arithmetic move:
    the MSB must be same as the signal bit.
*/
int int_shifts_are_arithmetic() {
    return (-1 >> 1) == -1;
    /*  If logical move:
        the MSB will be 0, and return 0.
        If arithmetic move:
        the MSB will be 1, and -1 = -1(return 1).*/
}