function D = PreProcessing(config, CP, SD, state)
%% Initialize diagnostics and create initial-time plots.
%
%  D = PreProcessing(config, CP, SD, state)
%
%  Populates the D struct (from CreateDiagnostics) with t=0 values:
%  invariants, amplification factors, position density, and errors.
%  Generates initial plots as requested by config.output.

assertStructType(config, 'config', 'PreProcessing');
assertStructType(CP, 'continuous_problem', 'PreProcessing');
assertStructType(SD, 'spatial_discretization', 'PreProcessing');

D = CreateDiagnostics();

%% Position density extraction
if config.monitor.posden || config.monitor.posden_size || config.output.plot_IC_posden
    posden = diag(state.U);
    posden = posden(:);
end

%% Initial condition plots
if config.output.plot_IC
    xy_saveplot_fig(SD.x, SD.y, real(state.U), ...
        'Real part of u_0(x,y)', '1_IC_Real', config, 'x', 'y');
    xy_saveplot_fig(SD.x, SD.y, abs(state.U), ...
        'Modulus of u_0(x,y)', '1_IC_Abs', config, 'x', 'y');

    fprintf('[PreProcessing] L^2 norm of IC: %g\n', ...
        sqrt(sum(sum(abs(state.U).^2)) * SD.dx * SD.dy));
    fprintf('[PreProcessing] L^inf norm of IC: %g\n', ...
        max(max(abs(state.U))));
end

if config.output.plot_IC_posden
    f_of_x_save_fig({SD.x}, {posden}, ...
        {'Initial position density, u_0(x,x)'}, '1_IC_posden', config, 'x');
end

%% Invariants at t=0
if config.output.do_invariants || config.monitor.invariants
    I = Invariants(CP, SD, state);
end

if config.output.do_invariants
    D.invariants.initial = I;
end

if config.monitor.invariants
    D.invariants.history = I;
end

%% Amplification factors at t=0
if config.output.do_amplific_factor || config.monitor.amplific_factor
    D.amplification.rho0 = 1;  % temporary, to compute initial amplitude
    [TAF, ~] = AmplificationFactor(CP, SD, D, state);
    D.amplification.rho0 = TAF;  % store actual initial amplitude (not an AF)

    D.amplification.TAF = 1;  % initial AF is 1 by definition
    D.amplification.IAF = 1;
end

%% Time vector
D.tvec = 0;

%% Position density tracking
if config.monitor.posden
    D.posden.snapshots = posden;
end

if config.monitor.posden_size
    D.posden.L2   = norm(posden) * sqrt(SD.dx);
    D.posden.Linf = max(abs(posden));
end

%% Constraint error placeholder
if config.monitor.constr_error
    D.constr_error = 0;  % no meaningful value at t=0
end

%% Error vs exact solution
if config.flags.compare2exact
    ErrU   = state.U - CP.ExactSolution(SD.X, SD.Y, state.t);
    ErrPhi = state.Phi - (CP.ExactSolution(SD.X, SD.X, state.t_minus_half) ...
                        - CP.ExactSolution(SD.Y, SD.Y, state.t_minus_half));
    D.error.L2_U    = norm(ErrU, 'fro') * SD.dx;
    D.error.Linf_U  = max(max(abs(ErrU)));
    D.error.L2_Phi  = norm(ErrPhi, 'fro') * SD.dx;
    D.error.Linf_Phi = max(max(abs(ErrPhi)));
end

end
