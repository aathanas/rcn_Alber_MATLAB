function state_new = timestep(CP,dt,state_old,SD)
% Alber timestep






PhiNew = 2*Phi_from_u(state_old.U) - state_old.Phi;


A=SD.eyeN - 1i*dt*CP.p*0.5*SD.Dhyp - 1i*0.5*CP.q*dt  * spdiags(PhiNew(:), 0, SD.N^2, SD.N^2);

uOld_vec=state_old.U(:);


% %% this would solve for u
spec_term = 1i*dt*CP.q * 0.5* SD.GammaMatrix .* PhiNew;
spec_term=spec_term(:);
uNew12 = A \ (uOld_vec + spec_term);


%% this solves for U = Gamma(x-y) + \delta u
% these have been converted to R = Gamma + u, but CP hasn't!!!!
% uNew12 = A \ uOld_vec;





 % disp('condition number')
 % cond(A)


%% extract U^{n+1}
uNew_vec = 2*uNew12 - uOld_vec;
Unew = unvec(uNew_vec, SD.N);


% disp('non hermitianity L^infty, L^2')
%   max(max( abs(  Unew' - Unew ) ) )
% 
%   norm(  Unew' - Unew ) / norm(Unew)


Unew = (Unew + Unew')/2;



state_new.U = Unew;
state_new.Phi = PhiNew;
state_new.t = state_old.t + dt;
state_new.t_minus_half = state_old.t + 0.5*dt;

end

