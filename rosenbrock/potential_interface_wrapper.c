/* Wrap the fortran interface into a c_wrapper to pass from the fortran side */
void c_dummy_potential_interface(const double *coordinates, double *energy,
                                 double *gradient, double *hessian,
                                 bool gradient_t, bool hessian_t);


void c_potential_wrapper(const double *coordinates, double *energy,
                                 double *gradient, double *hessian,
                                 bool gradient_t, bool hessian_t) {
  c_dummy_potential_interface(coordinates, energy, gradient, hessian,
                              gradient_t, hessian_t);
}

