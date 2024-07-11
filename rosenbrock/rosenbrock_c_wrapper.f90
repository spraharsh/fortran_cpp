module rosenbrock_c_wrapper
    use rosenbrock_mod, only: dummy_potential_interface
    use iso_c_binding, only: c_double, c_ptr, c_bool, c_f_pointer, c_associated
    implicit none
contains
    subroutine c_dummy_potential_interface(coordinates, c_ndof, energy, &
                                           gradient, hessian, &
                                           gradient_t, hessian_t) &
                                           bind(C, name="c_dummy_potential_interface")
        implicit none
        type(c_ptr), value :: coordinates
        type(c_ptr), value :: energy
        type(c_ptr), value :: gradient
        type(c_ptr), value :: hessian 
        type(c_ptr), value :: c_ndof ! Value attribute is required, otherwise you get a
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
end module rosenbrock_c_wrapper
