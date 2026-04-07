function state_new = timestep_lin(CP, dt, state_old, SD)
%% One timestep of the linearized Alber equation.
%
%  state_new = timestep_lin(CP, dt, state_old, SD)
%
%  Same scheme as timestep.m, but the implicit matrix A omits the
%  Phi-dependent diagonal:
%    A = I - i*dt*p/2 * Dhyp      (no -i*dt*q/2 * diag(Phi) term)
%
%  This corresponds to linearizing the Alber equation by dropping the
%  nonlinear coupling of Phi into the implicit solve.

PhiNew = 2*Phi_from_u(state_old.U) - state_old.Phi;

% Implicit matrix: identity + hyperbolic Laplacian only (linearized)
A = SD.eyeN - 1i*dt*CP.p*0.5*SD.Dhyp;

uOld_vec = state_old.U(:);

% Right-hand side: current solution + spectral (Gamma * Phi) forcing
spec_term = 1i*dt*CP.q * 0.5 * SD.GammaMatrix .* PhiNew;
spec_term = spec_term(:);
uNew12 = A \ (uOld_vec + spec_term);

% Leapfrog extrapolation to full step
uNew_vec = 2*uNew12 - uOld_vec;
Unew = unvec(uNew_vec, SD.N);

% Enforce Hermiticity (see timestep.m for rationale)
Unew = (Unew + Unew') / 2;

state_new.U            = Unew;
state_new.Phi          = PhiNew;
state_new.t            = state_old.t + dt;
state_new.t_minus_half = state_old.t + 0.5*dt;

end
