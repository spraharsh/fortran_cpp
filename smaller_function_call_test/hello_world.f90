! hello world subroutine
module smaller_function_call_test
    use iso_c_binding
    implicit none
contains
    subroutine hello_world() bind(C, name="hello_world")
        print *, "Hello, world!"
    end subroutine hello_world
end module smaller_function_call_test

    