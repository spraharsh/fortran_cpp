cmake_minimum_required(VERSION 3.10)

project(FortranCExample C Fortran)

# Enable Fortran support
enable_language(Fortran)

# Add the Fortran source file
add_library(fortran_code SHARED add.f90)

# Add the C executable
add_executable(main main.c)

# Link the Fortran library with the C executable
target_link_libraries(main PRIVATE fortran_code)