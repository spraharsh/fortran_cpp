// my_functions.h
#ifndef CVODE_CPP

#include <iostream>

#ifdef __cplusplus
extern "C" {
#endif

void hello_from_cpp();
double add_numbers(double a, double b);

class MyCppClass {
public:
  void say_hello() const { std::cout << "Hello from MyCppClass!" << std::endl; }
  double multiply_numbers(double a, double b) const { return a * b; }
};

#ifdef __cplusplus
}
#endif

#endif // !CVODE_CPP