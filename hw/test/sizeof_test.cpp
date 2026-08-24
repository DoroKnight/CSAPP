#include <iostream>
using namespace std;

int main() {
    int a = 10;
    unsigned b = 10;
    long c = b;
    cout << sizeof(a) << ' ' << sizeof(b) << ' ' << sizeof(c) << endl;
    return 0;
}

