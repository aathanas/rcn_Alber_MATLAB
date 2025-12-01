function CGD = PreProcessing(cfg,CP,SD,state)






%% plotting the intial state in accordance to cfg

if cfg.keep_track_posden || cfg.keep_track_posden_size || cfg.plot_IC_posden
    posden = diag(state.U);
    posden=posden(:);
end



if cfg.plot_IC

    % save a plot of the real part of the IC
    xy_saveplot_fig(SD.x,SD.y,real(state.U),'Real part of u_0(x,y)','1_IC_Real',cfg,'x','y');

    % save a plot of the modulus of the IC
    xy_saveplot_fig(SD.x,SD.y,abs(state.U),'Modulus of u_0(x,y)','1_IC_Abs',cfg,'x','y');


end


if cfg.plot_IC_posden

    % save a plot of the initial "position density"
    f_of_x_save_fig({SD.x},{posden},{'Initial position density, u_0(x,x)'},'1_IC_posden',cfg,'x')


end


%% Initialize the Diagnostics for this job

if cfg.do_invariants || cfg.keep_track_invariants
    I = Invariants(CP,SD,state); % this is a 3 by 1 column vector with the invariants
end


if cfg.do_invariants
    CGD.InitialInvariants = I; 
end

if cfg.keep_track_invariants % this will keep track of invariants on a coarse time grid
    CGD.I = I;
end

if cfg.do_amplific_factor || cfg.keep_track_amplific_factor
    CGD.rho0 = 1; % needed to perform the computation of the initial amplitude
    CGD.amplific_factor = AmplificationFactor(CP,SD,CGD,state);
    CGD.rho0 = CGD.amplific_factor; CGD.amplific_factor=1; % correct assignment of initial amplitude, AF
end


CGD.tvec = 0;
% tvec eventually will be a coarse time grid (0=t1,t2,...tn = T) on which
% various diagnostics will be computed. The fields of CGD will have the
% values of the diagnostics as required, as 1 by n or m by n arrays, where
% the jth column will corespond to the jth time in tvec


if cfg.keep_track_posden % the whole position density can be saved, this allows nice summary plots in the end
    CGD.posden = posden;
end

if cfg.keep_track_posden_size
    thisL2_norm =  norm(posden) * sqrt(SD.dx);
    thisLinf_norm =  max(abs(posden));
    CGD.posdenL2 = thisL2_norm;
    CGD.posdenLinf = thisLinf_norm;
end


if cfg.keep_track_constr_error
    CGD.constr_err = 0; % the constraint error doesn't really make sense at t=0, so it gets a placeholder value of 0
end



if cfg.compare2exact % L2 and Linfty errors for U and Phi
    ErrU = state.U - CP.ExactSolution(SD.X,SD.Y,state.t);
    ErrPhi = state.Phi - (  CP.ExactSolution(SD.X,SD.X,state.t_minus_half) - CP.ExactSolution(SD.Y,SD.Y,state.t_minus_half) );
    CGD.L2_err_U = norm(ErrU,'fro') * SD.dx;
    CGD.Linf_err_U= max(max(abs(ErrU)));
    CGD.L2_err_Phi = norm(ErrPhi,'fro') * SD.dx;
    CGD.Linf_err_Phi= max(max(abs(ErrPhi)));

end




end