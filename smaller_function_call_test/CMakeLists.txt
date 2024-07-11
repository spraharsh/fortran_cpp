cmake_minimum_required(VERSION 3.10)

# Project name
project(HelloWorldFortranC C CXX Fortran)

# Set the Fortran compiler (optional, CMake will usually detect it automatically)
# set(CMAKE_Fortran_COMPILER gfortran)

# Add the Fortran source file
add_library(hello_fortran STATIC hello_world.f90)

# Add the C source file
add_executable(hello_world hello_world.c)

# Link the Fortran library with the C executable
target_link_libraries(hello_world hello_fortran)