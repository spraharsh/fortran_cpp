#include <stdio.h>

void add(double *a, double *b, double *result);

int main() {
    double a = 5.0;
    double b = 3.0;
    double result;
    add(&a, &b, &result);

    printf("The result of adding %f and %f is %f\n", a, b, result);

    return 0;
}