function CGD = PostProcessing(cfg,CP,SD,state_old,CGD)


%% plot any required final time plots


if cfg.keep_track_posden || cfg.keep_track_posden_size || cfg.plot_final_posden
    posden = diag(state_old.U);
    posden=posden(:);
end


if cfg.plot_final_posden
    f_of_x_save_fig({SD.x},{posden},{'Final position density, u_0(x,x)'},'3_Final_posden',cfg,'x')
end


if cfg.plot_final_solution
    % save a plot of the real part of u at final time
    xy_saveplot_fig(SD.x,SD.y,real(state_old.U),'Real part of u(x,y,T)','3_Final_Re_u',cfg,'x','y');
    % save a plot of the modulus u at final time
    xy_saveplot_fig(SD.x,SD.y,abs(state_old.U),'Modulus of u(x,y,T)','3_Final_Abs_u',cfg,'x','y');
end






%% add an extra time step for t=T in the time-resolved diagnostics, update and plot

CGD.tvec = [CGD.tvec state_old.t];

% Final time invariants and comparison with their initial values
if cfg.do_invariants || cfg.keep_track_invariants
    I = Invariants(CP,SD,state_old); % this is a 3 by 1 column vector
end

if cfg.do_invariants
    CGD.FinalInvariants = I;

    InvAbsErr = abs(CGD.InitialInvariants - CGD.FinalInvariants);
    InvRelErr = abs( InvAbsErr ./ CGD.InitialInvariants );

    InvTable = table(CGD.InitialInvariants,CGD.FinalInvariants,InvAbsErr,InvRelErr,'VariableNames',{'I_j(0)','I_j(T)','Abs Err','Rel Err'})
end



if cfg.keep_track_invariants
    CGD.I = [CGD.I I];


    I1_nondim = abs( CGD.I(1,:) );
    I2_nondim = abs( CGD.I(2,:) );
    I3_nondim = abs( CGD.I(3,:) );

    I1_nondim = abs( (I1_nondim-I1_nondim(1) ) / I1_nondim(1));
    I2_nondim = abs( (I2_nondim-I2_nondim(1) ) / I2_nondim(1));
    I3_nondim = abs( (I3_nondim-I3_nondim(1) ) / I3_nondim(1));

    vec_cell = {I1_nondim, I2_nondim, I3_nondim};
    names_cell = {'I_1 (modulus of relative change in t)','I_2 (modulus of relative change in t)','I_3 (modulus of relative change in t)'};
    tvec_cell = {CGD.tvec, CGD.tvec, CGD.tvec};

    f_of_x_save_fig(tvec_cell,vec_cell,names_cell,'2_invariants_in_t',cfg,'t');

end


if cfg.keep_track_amplific_factor || cfg.do_amplific_factor
    CGD.amplific_factor = [CGD.amplific_factor AmplificationFactor(CP,SD,CGD,state_old)];
    CGD.amplific_factor = max(CGD.amplific_factor);
end



if cfg.keep_track_posden % the history of the position density can be saved, this allows nice summary plots in the end
    CGD.posden = [CGD.posden posden];
    xy_saveplot_fig(SD.x,CGD.tvec,CGD.posden','position density u(x,x,t)','2_Posden_x_t',cfg,'x','t');
end



if cfg.keep_track_posden_size
    thisL2_norm =  norm(posden) * sqrt(SD.dx);
    thisLinf_norm =  max(abs(posden));
    CGD.posdenL2 = [CGD.posdenL2 thisL2_norm];
    CGD.posdenLinf = [CGD.posdenLinf thisLinf_norm];

    vec_cell = {CGD.posdenL2, CGD.posdenLinf};
    names_cell = {'L^2 norm of position density','L^\infty norm of position density'};
    tvec_cell = {CGD.tvec, CGD.tvec};

    f_of_x_save_fig(tvec_cell,vec_cell,names_cell,'2_posden_size',cfg,'t');

end



if cfg.keep_track_constr_error
    CGD.constr_err = [CGD.constr_err 0]; % we have lost the previous timestep, so no meaningful value for constarint error here
    f_of_x_save_fig({CGD.tvec(2:end-1)},{CGD.constr_err(2:end-1)},{'Constraint error'},'2_constr_err_t',cfg,'t');
end


if cfg.compare2exact % L2 and Linfty errors for U and Phi
    ErrU = state_old.U - CP.ExactSolution(SD.X,SD.Y,state_old.t);
    ErrPhi = state_old.Phi - (  CP.ExactSolution(SD.X,SD.X,state_old.t_minus_half) - CP.ExactSolution(SD.Y,SD.Y,state_old.t_minus_half) );
    CGD.L2_err_U = [CGD.L2_err_U norm(ErrU,'fro') * SD.dx];
    CGD.Linf_err_U = [CGD.Linf_err_U max(max(abs(ErrU)))];
    CGD.L2_err_Phi = [CGD.L2_err_Phi norm(ErrPhi,'fro') * SD.dx];
    CGD.Linf_err_Phi = [CGD.Linf_err_Phi max(max(abs(ErrPhi)))];


    vec_cell = {CGD.L2_err_U, CGD.Linf_err_U, CGD.L2_err_Phi, CGD.Linf_err_Phi};
    names_cell = {'L^2 error for U','L^\infty error for U','L^2 error for \Phi','L^\infty error for \Phi'};
    tvec_cell = {CGD.tvec, CGD.tvec, CGD.tvec, CGD.tvec};

    if ~cfg.series_flag
        f_of_x_save_fig(tvec_cell,vec_cell,names_cell,'2_errors_in_t',cfg,'t');
    end

    Col_0 = ["Errors in U"';"Errors in Phi"];
    Col_1 = [CGD.L2_err_U(end); CGD.L2_err_Phi(end)];
    Col_2 = [CGD.Linf_err_U(end); CGD.Linf_err_Phi(end)];
    

     ErrTable = table(Col_1,Col_2,'VariableNames',{'L^2 errors','L^\infty errors'},'RowNames',Col_0)

    

end








end