module test_rosenbrock
    use rosenbrock_mod
    implicit none
contains
    subroutine test_dummy_potential_interface()
        ! Inputs
        real(8), dimension(2) :: coordinates
        logical :: gradient_t, hessian_t
        ! Outputs
        real(8) :: energy
        real(8), dimension(2) :: gradient
        real(8), dimension(2, 2) :: hessian
        ! Expected values
        real(8) :: expected_energy
        real(8), dimension(2) :: expected_gradient
        real(8), dimension(2, 2) :: expected_hessian

        ! Set test coordinates
        coordinates = [1.0d0, 1.0d0]
        gradient_t = .true.
        hessian_t = .true.

        ! Call the dummy potential interface
        call dummy_potential_interface(coordinates, energy, gradient, hessian, gradient_t, hessian_t)

        ! Expected values for coordinates (1, 1)
        expected_energy = 0.0d0
        expected_gradient = [0.0d0, 0.0d0]
        expected_hessian = reshape([802.0d0, -400.0d0, -400.0d0, 200.0d0], shape(hessian))

        ! Check the results
        call check_value(energy, expected_energy, 'Energy')
        call check_array(gradient, expected_gradient, 'Gradient')
        call check_matrix(hessian, expected_hessian, 'Hessian')

        print *, 'All tests passed!'
    end subroutine test_dummy_potential_interface

    subroutine check_value(value, expected, name)
        real(8), intent(in) :: value, expected
        character(len=*), intent(in) :: name
        if (abs(value - expected) > 1.0d-6) then
                print *, 'Test failed for', name, ': expected', expected, 'but got', value
            stop
        end if
    end subroutine check_value

    subroutine check_array(array, expected, name)
        real(8), dimension(:), intent(in) :: array, expected
        character(len=*), intent(in) :: name
        integer :: i
        do i = 1, size(array)
            if (abs(array(i) - expected(i)) > 1.0d-6) then
                print *, 'Test failed for', name, 'at index', i, &
                    ': expected', expected(i), 'but got', array(i)
                stop
            end if
        end do
    end subroutine check_array

    subroutine check_matrix(matrix, expected, name)
        real(8), dimension(:,:), intent(in) :: matrix, expected
        character(len=*), intent(in) :: name
        integer :: i, j
        do i = 1, size(matrix, 1)
            do j = 1, size(matrix, 2)
                if (abs(matrix(i, j) - expected(i, j)) > 1.0d-6) then
                    print *, 'Test failed for', name, 'at index (', i, ',', j, '):'
                    print *, 'Expected:', expected(i, j)
                    print *, 'Got:', matrix(i, j)
                    stop
                end if
            end do
        end do
    end subroutine check_matrix
end module test_rosenbrock

program main
    use test_rosenbrock
    implicit none
    call test_dummy_potential_interface()
end program main

