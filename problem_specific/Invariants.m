function I = Invariants(CP, SD, state)
%% Compute the four conserved quantities of the Alber equation.
%
%  I = Invariants(CP, SD, state)
%
%  Returns a 4x1 vector [I0; I1; I2; I3] where:
%    I0 = integral |Gamma(x-y) + U(x,y,t)|^2 dx dy   (modified energy)
%    I1 = integral diag(U) dx                          (mass)
%    I2 = integral (nabla_{x-y}) diag(U) dx            (momentum)
%    I3 = (q/p) integral diag(U^2) + (nabla_{x-y})^2 diag(U) dx

assertStructType(CP, 'continuous_problem', 'Invariants');
assertStructType(SD, 'spatial_discretization', 'Invariants');

I0 = sum(sum(abs(SD.GammaMatrix + state.U).^2)) * SD.dx * SD.dy;
I1 = sum(diag(state.U)) * SD.dx;
I2 = sum(diag(unvec(SD.Nabla_x_minus_y * state.U(:), SD.N))) * SD.dx;
I3 = sum(diag((CP.q/CP.p) * state.U.^2 ...
    + unvec((SD.Nabla_x_minus_y^2) * state.U(:), SD.N))) * SD.dx;

I = [I0; I1; I2; I3];

end
