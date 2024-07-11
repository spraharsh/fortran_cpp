module add_module
    use iso_c_binding
    implicit none
contains
    subroutine add(a, b, result) bind(C, name="add")
        real(c_double), intent(in) :: a, b
        real(c_double), intent(out) :: result
        result = a + b
    end subroutine add
end module add_module