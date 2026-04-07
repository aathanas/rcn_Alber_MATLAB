function state_new = timestep(CP, dt, state_old, SD)
%% One timestep of the (nonlinear) Alber equation.
%
%  state_new = timestep(CP, dt, state_old, SD)
%
%  Implicit midpoint / leapfrog scheme:
%    1. Extrapolate Phi:  Phi^{n+1/2} = 2*Phi_from_u(U^n) - Phi^{n-1/2}
%    2. Build implicit matrix A = I - i*dt*p/2 * Dhyp - i*dt*q/2 * diag(Phi)
%    3. Solve for midpoint:  A * u^{n+1/2} = u^n + spectral_term
%    4. Leapfrog:  u^{n+1} = 2*u^{n+1/2} - u^n
%    5. Enforce Hermiticity:  U = (U + U')/2

PhiNew = 2*Phi_from_u(state_old.U) - state_old.Phi;

% Implicit matrix: identity + hyperbolic Laplacian + nonlinear Phi diagonal
A = SD.eyeN - 1i*dt*CP.p*0.5*SD.Dhyp ...
    - 1i*0.5*CP.q*dt * spdiags(PhiNew(:), 0, SD.N^2, SD.N^2);

uOld_vec = state_old.U(:);

% Right-hand side: current solution + spectral (Gamma * Phi) forcing
spec_term = 1i*dt*CP.q * 0.5 * SD.GammaMatrix .* PhiNew;
spec_term = spec_term(:);
uNew12 = A \ (uOld_vec + spec_term);

% Leapfrog extrapolation to full step
uNew_vec = 2*uNew12 - uOld_vec;
Unew = unvec(uNew_vec, SD.N);

% Enforce Hermiticity (U should be Hermitian by the physics, but
% roundoff in the linear solve can break this; symmetrizing preserves it)
Unew = (Unew + Unew') / 2;

state_new.U            = Unew;
state_new.Phi          = PhiNew;
state_new.t            = state_old.t + dt;
state_new.t_minus_half = state_old.t + 0.5*dt;

end
