module hello_module
  use iso_c_binding
  implicit none
contains
  subroutine say_hello() bind(C, name="hello_world")
    implicit none
    print *, "Hello, World from Fortran!"
  end subroutine say_hello

  subroutine call_function_wrapper(cptr) bind(C, name="call_function_wrapper")
    use iso_c_binding
    implicit none
    type(c_funptr), value :: cptr
    interface
      subroutine c_fun() bind(C)
        use iso_c_binding
        implicit none
      end subroutine c_fun
    end interface
    call c_fun()
  end subroutine call_function_wrapper
end module hello_module
