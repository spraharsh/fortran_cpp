cmake_minimum_required(VERSION 3.10)
project(FortranCppInterop)

# Enable Fortran and C++ languages
enable_language(Fortran)
enable_language(CXX)

# Set the Fortran and C++ source files
set(FORTRAN_SOURCES fortran_program.f90)
set(CPP_SOURCES my_functions.cpp)

include_directories(${CMAKE_CURRENT_SOURCE_DIR})

# Add an executable target
add_executable(my_program ${FORTRAN_SOURCES} ${CPP_SOURCES})

# Link the C++ standard library (this is usually done automatically)
target_link_libraries(my_program stdc++)