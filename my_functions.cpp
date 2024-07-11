#include "my_functions.hpp"
#include <iostream>

extern "C" {

void hello_from_cpp() { std::cout << "Hello from C++!" << std::endl; }

double add_numbers(double a, double b) { return a + b; }

void create_and_use_cpp_class() {
  MyCppClass my_cpp_class;
  my_cpp_class.say_hello();
  double result = my_cpp_class.multiply_numbers(3.0, 4.0);
  std::cout << "3.0 * 4.0 = " << result << std::endl;
}

void create_and_use() {
  MyCppClass my_cpp_class;
  my_cpp_class.say_hello();
  double result = my_cpp_class.multiply_numbers(3.0, 4.0);
  std::cout << "3.0 * 4.0 = " << result << std::endl;
}
}