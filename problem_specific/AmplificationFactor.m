function [TAF, IAF] = AmplificationFactor(CP, SD, D, state)
%% Compute total and inhomogeneity amplification factors.
%
%  [TAF, IAF] = AmplificationFactor(CP, SD, D, state)
%
%  TAF = max|Gamma(x-y) + U(x,y,t)| / D.amplification.rho0
%        Measures amplification of the full field relative to t=0.
%
%  IAF = max|U(x,y,t)| / max|IC(x,y)|
%        Measures amplification of the inhomogeneity alone.

TAF = max(max(abs(state.U + SD.GammaMatrix))) / D.amplification.rho0;

IAF = max(max(abs(state.U))) / max(max(abs(CP.IC(SD.X, SD.Y))));

end
