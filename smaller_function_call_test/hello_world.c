// Simple hello world routine as called from fortran

#include <stdio.h>

extern void hello_world();

typedef void (*Caller)(void);

void call_function(Caller c) {
    c();
}





int main() {
    printf("Calling Fortran from C:\n");
    call_function(hello_world);
    return 0;
}
