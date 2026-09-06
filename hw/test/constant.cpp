#include <iostream>
#include <ctime>

int main() {
    const std::time_t now_time = std::time(nullptr);
    // Error: 'constexpr' variable must be initialized by a constant expression.
    // constexpr std::time_t compare_time = std::time(nullptr);
    constexpr int number = 100;
    std::cout << "Now time is: \n" << now_time << "\n" 
            << "I pick up $" << number << '\n';
    return 0;
}