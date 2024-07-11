! my_fortran_program.f90
module cpp_functions
    use, intrinsic :: iso_c_binding
    implicit none

    interface
        subroutine hello_from_cpp() bind(C, name="hello_from_cpp")
            use iso_c_binding
        end subroutine hello_from_cpp

        function add_numbers(a, b) bind(C, name="add_numbers") result(res)
            use iso_c_binding
            real(c_double), value :: a, b
            real(c_double) :: res
        end function add_numbers

        subroutine create_and_use() bind(C, name="create_and_use")
            use iso_c_binding
        end subroutine create_and_use
    end interface
end module cpp_functions

program main
    use cpp_functions
    implicit none

    call hello_from_cpp()

    call create_and_use()

    print *, '3.0 + 4.0 = ', add_numbers(3.0d0, 4.0d0)
end program main