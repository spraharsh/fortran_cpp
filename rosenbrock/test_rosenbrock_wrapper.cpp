#include "gmin_interface.hpp"
#include "pele/array.hpp"
#include <iostream>
#include <memory>
#include <vector>

// Function prototype for the Fortran subroutine
extern "C" {
void c_dummy_potential_interface(const double *coordinates, int *ndof,
                                 double *energy, double *gradient,
                                 double *hessian, bool gradient_t,
                                 bool hessian_t);
}

int main() {
  // Define the dimensions
  const int n_coordinates = 2;
  const int n_gradient = 2;
  const int n_hessian = 4;

  // Create vectors to manage memory automatically
  std::vector<double> coordinates(n_coordinates);
  auto energy = std::make_unique<double>();
  std::vector<double> gradient(n_gradient);
  std::vector<double> hessian(n_hessian);
  bool gradient_t = true;
  bool hessian_t = true;

  coordinates[0] = 1.0;
  coordinates[1] = 1.0;

  for (int i = 0; i < n_gradient; ++i) {
    gradient[i] = 0;
  }

  for (int i = 0; i < n_hessian; ++i) {
    hessian[i] = 0;
  }
  *energy = 10;

  // Call the Fortran subroutine
  int ndof = 2;
  std::cout << "ndof: " << ndof << std::endl;
  c_dummy_potential_interface(coordinates.data(), &ndof, energy.get(),
                              gradient.data(), hessian.data(), gradient_t,
                              hessian_t);
  std::cout << "ndof: " << ndof << std::endl;

  // Use the results as needed
  std::cout << "Energy: " << *energy << std::endl;
  // Print other results as needed
  std::cout << "Gradient: ";
  for (int i = 0; i < n_gradient; ++i) {
    std::cout << gradient[i] << " ";
  }

  std::cout << "Hessian: ";
  for (int i = 0; i < n_hessian; ++i) {
    std::cout << hessian[i] << " ";
  }

  PotentialGMINInterface pot_inf(c_dummy_potential_interface, 2);
  std::cout << "ndof: " << ndof << std::endl;
  // std::cout << std::endl;
  Array<double> coordinates_pele = {1.0, 1.0};
  std::cout << "Energy: " << pot_inf.get_energy(coordinates_pele) << std::endl;
  Array<double> gradient_pele(2);
  Array<double> hessian_pele(4);

  pot_inf.get_energy_gradient(coordinates, gradient_pele);
  std::cout << "ndof: " << ndof << std::endl;
  std::cout << "Gradient: ";
  std::cout << gradient_pele << std::endl;
  std::cout << "ndof: " << ndof << std::endl;
  pot_inf.get_energy_gradient_hessian(coordinates, gradient_pele, hessian_pele);
  std::cout << "ndof: " << ndof << std::endl;

  std::cout << "Hessian: ";
  std::cout << hessian_pele << std::endl;
  std::cout << "Gradient: ";
  std::cout << gradient_pele << std::endl;
  Array<double> start_opt_coords = {0.0, 0.0};
  double ereal = -1;
  bool converged = false;
  double tol = 1e-6;
  double rtol = 1e-6;
  int max_iter = 1000;
  int iter = 0;
  std::cout << "ndof: " << ndof << std::endl;
  CVODE_quench(&ndof, start_opt_coords.data(), &ereal, &converged, &rtol, &tol,
               &iter, &max_iter, c_dummy_potential_interface);
  std::cout << "Energy: " << ereal << std::endl;
  std::cout << "Converged: " << converged << std::endl;
  std::cout << "Coordinates: " << start_opt_coords << std::endl;
  return 0;
}