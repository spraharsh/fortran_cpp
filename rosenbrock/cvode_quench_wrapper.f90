module quench_module
  use iso_c_binding
  use rosenbrock_mod, only: dummy_potential_interface
  implicit none

  interface
    subroutine CVODE_quench(ndof, coordinates, ereal, converged, &
     rtol, convergence_tol, iter, maxit, potential_func) &
      bind(C, name="CVODE_quench")
      import :: c_int, c_double, c_bool, c_ptr
      integer(c_int), intent(in) :: ndof
      real(c_double), intent(inout) :: coordinates(*)
      real(c_double), intent(out) :: ereal
      logical(c_bool), intent(out) :: converged
      real(c_double), intent(in) :: rtol
      real(c_double), intent(in) :: convergence_tol
      integer(c_int), intent(out) :: iter
      integer(c_int), intent(in) :: maxit
      type(c_ptr), value :: potential_func
    end subroutine CVODE_quench
  end interface

contains

  subroutine fortran_quench(ndof, coordinates, ereal, converged, &
      rtol, convergence_tol, iter, maxit)
    use iso_c_binding
    implicit none
    integer(c_int), intent(in) :: ndof
    real(c_double), intent(inout) :: coordinates(*)
    real(c_double), intent(out) :: ereal
    logical, intent(out) :: converged
    real(c_double), intent(in) :: rtol
    real(c_double), intent(in) :: convergence_tol
    integer(c_int), intent(out) :: iter
    integer(c_int), intent(in) :: maxit
    type(c_funptr) :: potential_func
    logical(c_bool) :: c_converged

    ! Assign the Fortran potential function to a C function pointer
    potential_func = c_funloc(c_dummy_potential_interface)

    ! Call the C++ CVODE_quench function
    call CVODE_quench(ndof, coordinates, ereal, c_converged, &
          rtol, convergence_tol, iter, maxit, potential_func)

    ! Convert c_converged back to Fortran logical type
    converged = c_converged

  end subroutine fortran_quench

  subroutine c_dummy_potential_interface(coordinates, c_ndof, energy, &
                                           gradient, hessian, &
                                           gradient_t, hessian_t) &
                                           bind(C, name="c_dummy_potential_interface")
        implicit none
        type(c_ptr), value :: coordinates
        type(c_ptr), value :: c_ndof
        type(c_ptr), value :: energy
        type(c_ptr), value :: gradient
        type(c_ptr), value :: hessian
        
        logical(c_bool), value :: gradient_t
        logical(c_bool), value :: hessian_t

        real(c_double), pointer :: coordinates_ptr(:)
        real(c_double), pointer :: energy_ptr
        real(c_double), pointer :: gradient_ptr(:)
        real(c_double), pointer :: hessian_ptr(:,:)
        
        integer :: ndof
        logical :: gradient_t_bool
        logical :: hessian_t_bool
        real(c_double) :: energy_scalar
        integer, pointer :: ndof_ptr

        call c_f_pointer(c_ndof, ndof_ptr)
        ndof = ndof_ptr

        
        call c_f_pointer(coordinates, coordinates_ptr, [ndof])
        call c_f_pointer(energy, energy_ptr) ! Handle energy as a pointer
        call c_f_pointer(gradient, gradient_ptr, [ndof])
        call c_f_pointer(hessian, hessian_ptr, [ndof, ndof])
        gradient_t_bool = logical(gradient_t)
        hessian_t_bool = logical(hessian_t)


        energy_scalar = energy_ptr  ! Copy the value from C pointer to Fortran scalar

        call dummy_potential_interface(coordinates_ptr, energy_scalar, gradient_ptr, hessian_ptr, gradient_t_bool, hessian_t_bool)
        
        energy_ptr = energy_scalar  ! Copy the result back to the C pointer
    end subroutine c_dummy_potential_interface
end module quench_module


module test_cvode_wrapper
  use quench_module
  use rosenbrock_mod
  implicit none

  contains
    subroutine test_quench()
        ! Inputs
        real(8), dimension(2) :: coordinates
        logical :: gradient_t, hessian_t
        ! Outputs
        real(8) :: energy
        real(8), dimension(2) :: gradient
        real(8), dimension(2, 2) :: hessian
        ! Expected values
        real(8) :: expected_energy
        real(8), dimension(2) :: expected_coordinates
        integer :: iter
        logical :: converged

        coordinates = [0.0d0, 0.0d0] ! Initial coordinates rosenbrock
        expected_coordinates = [1.0d0, 1.0d0] ! Expected coordinates after quenching

        energy = -1000.0d0 ! initialize energy to a large negative number so we know if it is not updated
        
        ! Call the Fortran quench function
        call fortran_quench(2, coordinates, energy, converged, 1.0d-6, 1.0d-6, iter, 1000)

        ! Expected values for coordinates (0, 0)
        expected_energy = 0.0d0

        ! Check the energy
        if (abs(energy - expected_energy) > 1.0d-6) then
            print *, "Energy is not correct"
            print *, "Expected energy: ", expected_energy
            print *, "Computed energy: ", energy
        end if


        ! Check the coordinates
        if (any(abs(coordinates - expected_coordinates) > 1.0d-6)) then
            print *, "Coordinates are not correct"
            print *, "Expected coordinates: ", expected_coordinates
            print *, "Computed coordinates: ", coordinates
        end if

        ! print steps taken
        print *, "Steps taken: ", iter

        ! print final coordinates
        print *, "Final coordinates: ", coordinates


    end subroutine test_quench
end module test_cvode_wrapper


program test_cvode
  use test_cvode_wrapper
  implicit none

  call test_quench()

end program test_cvode



