function D = UpdateDiagnostics(config, CP, SD, state_old, state_new, D)
%% Record mid-run diagnostics at the current timestep.
%
%  D = UpdateDiagnostics(config, CP, SD, state_old, state_new, D)
%
%  Called every config.monitor.frequency timesteps during the main loop.
%  Appends current values to the growing arrays in D.

%% Position density extraction
if config.monitor.posden || config.monitor.posden_size
    posden = diag(state_new.U);
    posden = posden(:);
end

%% Time vector
D.tvec = [D.tvec, state_new.t];

%% Position density snapshots
if config.monitor.posden
    D.posden.snapshots = [D.posden.snapshots, posden];
end

if config.monitor.posden_size
    D.posden.L2   = [D.posden.L2,   norm(posden) * sqrt(SD.dx)];
    D.posden.Linf = [D.posden.Linf, max(abs(posden))];
end

%% Invariants
if config.monitor.invariants
    I = Invariants(CP, SD, state_new);
    D.invariants.history = [D.invariants.history, I];
end

%% Amplification factors
if config.monitor.amplific_factor
    [TAF, IAF] = AmplificationFactor(CP, SD, D, state_new);
    D.amplification.TAF = [D.amplification.TAF, TAF];
    D.amplification.IAF = [D.amplification.IAF, IAF];
end

%% Constraint error
if config.monitor.constr_error
    Phi1 = Phi_from_u(state_old.U);
    Phi2 = Phi_from_u(state_new.U);
    constrerr = max(max(abs((Phi1 + Phi2)/2 - state_new.Phi)));
    D.constr_error = [D.constr_error, constrerr];
end

%% Error vs exact solution
if config.flags.compare2exact
    ErrU   = state_new.U - CP.ExactSolution(SD.X, SD.Y, state_new.t);
    ErrPhi = state_new.Phi - (CP.ExactSolution(SD.X, SD.X, state_new.t_minus_half) ...
                            - CP.ExactSolution(SD.Y, SD.Y, state_new.t_minus_half));
    D.error.L2_U    = [D.error.L2_U,    norm(ErrU, 'fro') * SD.dx];
    D.error.Linf_U  = [D.error.Linf_U,  max(max(abs(ErrU)))];
    D.error.L2_Phi  = [D.error.L2_Phi,  norm(ErrPhi, 'fro') * SD.dx];
    D.error.Linf_Phi = [D.error.Linf_Phi, max(max(abs(ErrPhi)))];
end

end
