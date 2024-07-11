/* File: main.c */
#include <stdio.h>

/* Declaration of the Fortran function */
extern int add_(int *a, int *b);

int main() {
    int x = 5;
    int y = 3;
    int result;

    result = add_(&x, &y);

    printf("The sum of %d and %d is %d\n", x, y, result);
    return 0;
}