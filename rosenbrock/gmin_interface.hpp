#ifndef GMIN_INTERFACE_PELE
#define GMIN_INTERFACE_PELE

#include <pele/array.hpp>
#include <pele/base_potential.hpp>
#include <pele/cvode.hpp>

typedef void (*PotentialFunc)(const double *, int *, double *, double *,
                              double *, bool, bool);

using namespace pele;
class PotentialGMINInterface : public pele::BasePotential {
private:
  PotentialFunc potential_gmin;
  int n_dof_;

public:
  PotentialGMINInterface(PotentialFunc potential_gmin, int n_dof)
      : potential_gmin(potential_gmin), n_dof_(n_dof) {}

  double get_energy(pele::Array<double> const &coordinates) {
    double energy;
    potential_gmin(coordinates.data(), &n_dof_, &energy, nullptr, nullptr,
                   false, false);
    return energy;
  }
  double get_energy_gradient(const pele::Array<double> &coordinates,
                             pele::Array<double> &gradient) {
    double energy;
    potential_gmin(coordinates.data(), &n_dof_, &energy, gradient.data(),
                   nullptr, true, false);
    return energy;
  }
  double get_energy_gradient_hessian(const pele::Array<double> &coordinates,
                                     pele::Array<double> &gradient,
                                     pele::Array<double> &hessian) {
    double energy;
    potential_gmin(coordinates.data(), &n_dof_, &energy, gradient.data(),
                   hessian.data(), true, true);
    return energy;
  }
  virtual ~PotentialGMINInterface(){};
};

extern "C" {
void CVODE_quench(int *ndof, double *coordinates, double *ereal,
                  bool *converged, double *rtol, double *convergence_tol,
                  int *iter, int *maxit, PotentialFunc potential_func);
}

#endif // !STUFF