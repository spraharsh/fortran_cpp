cmake_minimum_required(VERSION 3.10)
set(CMAKE_BUILD_TYPE Debug)

# Project name and language
project(Rosenbrock_Fortran_Project LANGUAGES Fortran CXX)
set(CMAKE_CPP_COMPILER g++)

# export compile commands
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

set(FORTRAN_BASE_SOURCES
    rosenbrock.f90
    rosenbrock_c_wrapper.f90
)
set(ROSENBROCK_SOURCE rosenbrock.f90)

find_package(LAPACK REQUIRED)

set(GMIN_INTERFACE_LIB_SOURCE
    gmin_interface.cpp
)
set(GMIN_INTERFACE_LIB_HEADER
    gmin_interface.hpp)

# Add the source files
set(FORTRAN_TARGET_SOURCES
    test_rosenbrock.f90
)

set(CXX_TARGET_SOURCES
    test_rosenbrock_wrapper.cpp)

set(FORTRAN_CVODE_OPT_SOURCES
    cvode_quench_wrapper.f90
)

set(PELE_DIR /home/praharsh/research/bv-libraries/pele)
set(PELE_INCLUDE_DIR ${PELE_DIR}/source)
set(PELE_BINARY_DIR ${PELE_DIR}/build/cmake)
set(PELE_EXTERNAL_DIR ${PELE_DIR}/extern/install)
set(PELE_DEP_INCLUDE_DIR ${PELE_EXTERNAL_DIR}/include)

# #################################### sundials #######################################
set(EXT_INCLUDE_DIR
    ${PELE_EXTERNAL_DIR}/include
    CACHE PATH "Location of header files")

if(EXISTS "${PELE_EXTERNAL_DIR}/lib")
    set(SUNDIALS_LIBRARY_DIR
        ${PELE_EXTERNAL_DIR}/lib
        CACHE PATH "Location of SUNDIALS libraries")
else()
    set(SUNDIALS_LIBRARY_DIR
        ${PELE_EXTERNAL_DIR}/lib64
        CACHE PATH "Location of SUNDIALS libraries")
endif()

message(STATUS "SUNDIALS_LIBRARY_DIR: ${SUNDIALS_LIBRARY_DIR}")

set(LAPACKE_INCLUDE_DIR
    ${PELE_DIR}/extern/install/include/Eigen/src/misc
    CACHE PATH "Location of lapacke include")

# Find the SUNDIALS libraries
find_library(SUNDIALS_SOLVER_LIB
    sundials_cvode PATHS ${SUNDIALS_LIBRARY_DIR} NO_DEFAULT_PATH
    DOC "CVODE library")

find_library(SUNDIALS_NVEC_LIB
    sundials_nvecserial PATHS ${SUNDIALS_LIBRARY_DIR} NO_DEFAULT_PATH
    DOC "NVECTOR_SERIAL library")

set(SUNDIALS_LIBRARIES
    -L${SUNDIALS_LIBRARY_DIR}
    ${SUNDIALS_SOLVER_LIB}
    ${SUNDIALS_NVEC_LIB}
    ${SUNDIALS_MANYVEC_LIB}
    ${SUNDIALS_EXTRA_LIBS})

message(STATUS "SUNDIALS_LIBRARIES: ${SUNDIALS_LIBRARIES}")

# add gmin interface library
add_library(gmin_interface_lib SHARED ${GMIN_INTERFACE_LIB_SOURCE})
target_link_libraries(gmin_interface_lib PUBLIC ${PELE_BINARY_DIR}/libpele_lib.so)
target_link_libraries(gmin_interface_lib PUBLIC ${SUNDIALS_LIBRARIES})
target_include_directories(gmin_interface_lib PUBLIC ${PELE_DEP_INCLUDE_DIR})
target_include_directories(gmin_interface_lib PUBLIC ${PELE_INCLUDE_DIR})
target_include_directories(gmin_interface_lib PUBLIC ${LAPACKE_INCLUDE_DIR})
target_link_libraries(gmin_interface_lib PUBLIC ${LAPACK_LIBRARIES})

add_library(rosenbrock_lib SHARED ${ROSENBROCK_SOURCE})

# Add the executable
add_executable(rosenbrock_executable ${FORTRAN_BASE_SOURCES} ${FORTRAN_TARGET_SOURCES})
add_executable(rosenbrock_cpp_executable ${FORTRAN_BASE_SOURCES} ${CXX_TARGET_SOURCES})

add_executable(fortran_cvode_executable ${FORTRAN_CVODE_OPT_SOURCES})

# include pele include directories
target_include_directories(rosenbrock_cpp_executable PUBLIC ${PELE_DEP_INCLUDE_DIR})
target_include_directories(rosenbrock_cpp_executable PUBLIC ${PELE_INCLUDE_DIR})
target_include_directories(rosenbrock_cpp_executable PUBLIC ${LAPACKE_INCLUDE_DIR})

target_link_libraries(fortran_cvode_executable PUBLIC rosenbrock_lib)

# include all for the fortran cvode opt executable
# target_include_directories(fortran_cvode_executable PUBLIC ${PELE_DEP_INCLUDE_DIR})
# target_include_directories(fortran_cvode_executable PUBLIC ${PELE_INCLUDE_DIR})
# target_include_directories(fortran_cvode_executable PUBLIC ${LAPACKE_INCLUDE_DIR})
target_link_libraries(rosenbrock_cpp_executable PUBLIC ${SUNDIALS_LIBRARIES})
target_link_libraries(rosenbrock_cpp_executable PUBLIC ${PELE_BINARY_DIR}/libpele_lib.so)
target_link_libraries(rosenbrock_cpp_executable PUBLIC ${SUNDIALS_LIBRARIES})
target_link_libraries(rosenbrock_cpp_executable PUBLIC ${LAPACK_LIBRARIES})
target_link_libraries(rosenbrock_cpp_executable PUBLIC gmin_interface_lib)

# link all for the fortran cvode opt executable
target_link_libraries(fortran_cvode_executable PUBLIC ${SUNDIALS_LIBRARIES})
target_link_libraries(fortran_cvode_executable PUBLIC ${PELE_BINARY_DIR}/libpele_lib.so)
target_link_libraries(fortran_cvode_executable PUBLIC ${SUNDIALS_LIBRARIES})
target_link_libraries(fortran_cvode_executable PUBLIC ${LAPACK_LIBRARIES})
target_link_libraries(fortran_cvode_executable PUBLIC gmin_interface_lib)

# Set the Fortran standard
set_target_properties(rosenbrock_executable PROPERTIES Fortran_MODULE_DIRECTORY ${CMAKE_BINARY_DIR}/modules)
set_target_properties(rosenbrock_executable PROPERTIES LINKER_LANGUAGE Fortran)

# set the fortran standard for the cvode opt executable
set_target_properties(fortran_cvode_executable PROPERTIES Fortran_MODULE_DIRECTORY ${CMAKE_BINARY_DIR}/modules)
set_target_properties(fortran_cvode_executable PROPERTIES LINKER_LANGUAGE Fortran)

# Set the C++ standard
set_target_properties(rosenbrock_cpp_executable PROPERTIES CXX_STANDARD 17)
set_target_properties(rosenbrock_cpp_executable PROPERTIES CXX_STANDARD_REQUIRED ON)