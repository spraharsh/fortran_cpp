#include "gmin_interface.hpp"

extern "C" {
void CVODE_quench(int *ndof, double *coordinates, double *ereal,
                  bool *converged, double *rtol, double *convergence_tol,
                  int *iter, int *maxit, PotentialFunc potential_func) {
  std::cout << "starting coords" << coordinates;
  std::cout << "ndof" << *ndof;
  std::shared_ptr<BasePotential> ptr = std::make_shared<PotentialGMINInterface>(
      PotentialGMINInterface(potential_func, *ndof));
  pele::Array<double> start_coords(coordinates, *ndof);

  pele::CVODEBDFOptimizer opt(ptr, start_coords, *convergence_tol, *rtol,
                              *rtol * 1e-1, DENSE, false);
  std::cout << "maxit" << *maxit;
  opt.run(*maxit);

  std::cout << "energy" << opt.get_f();
  std::cout << "niter" << opt.get_niter();
  std::cout << "converged" << opt.stop_criterion_satisfied();
  std::cout << "ndof within quench"
            << " " << *ndof << std::endl;
  std::cout << "coordinates"
            << " " << start_coords << std::endl;
  std::cout << "coordinates" << opt.get_x() << std::endl;
  start_coords.assign(opt.get_x());
  *iter = opt.get_niter();
  *converged = opt.stop_criterion_satisfied();
}
}