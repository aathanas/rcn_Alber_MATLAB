function CGD = UpdateDiagnostics(cfg,CP,SD,state_old,state_new,CGD)



if cfg.keep_track_posden || cfg.keep_track_posden_size
    posden = diag(state_new.U);
    posden=posden(:);
end



CGD.tvec = [CGD.tvec state_new.t];



if cfg.keep_track_posden % the whole position density can be save, this allows nice summary plots in the end
    CGD.posden = [CGD.posden posden];
end

if cfg.keep_track_posden_size
    thisL2_norm =  norm(posden) * sqrt(SD.dx);
    thisLinf_norm =  max(abs(posden));
    CGD.posdenL2 = [CGD.posdenL2 thisL2_norm];
    CGD.posdenLinf = [CGD.posdenLinf thisLinf_norm];

end

if cfg.keep_track_invariants
    I = Invariants(CP,SD,state_new); % this is a 3 by 1 column vector
    CGD.I = [CGD.I  I];
end

if cfg.keep_track_amplific_factor
    CGD.amplific_factor = [CGD.amplific_factor AmplificationFactor(CP,SD,CGD,state_new)];
end




if cfg.keep_track_constr_error

    Phi1 = Phi_from_u(state_old.U);
    Phi2 = Phi_from_u(state_new.U);

    constrerr_this = max(max(abs( (Phi1+Phi2)/2 - state_new.Phi )));

    CGD.constr_err = [CGD.constr_err constrerr_this]; % the constraint error doesn't really make sense at t=0
end


if cfg.compare2exact % L2 and Linfty errors for U and Phi
    ErrU = state_new.U - CP.ExactSolution(SD.X,SD.Y,state_new.t);
    ErrPhi = state_new.Phi - (  CP.ExactSolution(SD.X,SD.X,state_new.t_minus_half) - CP.ExactSolution(SD.Y,SD.Y,state_new.t_minus_half) );
    CGD.L2_err_U = [CGD.L2_err_U norm(ErrU,'fro') * SD.dx];
    CGD.Linf_err_U = [CGD.Linf_err_U max(max(abs(ErrU)))];
    CGD.L2_err_Phi = [CGD.L2_err_Phi norm(ErrPhi,'fro') * SD.dx];
    CGD.Linf_err_Phi = [CGD.Linf_err_Phi max(max(abs(ErrPhi)))];

end





end