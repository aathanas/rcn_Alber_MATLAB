function D = PostProcessing(config, CP, SD, state_old, D)
%% Final-time diagnostics, invariant comparison, and end-of-run plots.
%
%  D = PostProcessing(config, CP, SD, state_old, D)
%
%  Appends final-time values to D, computes invariant drift, and
%  generates all output plots requested by config.output and config.monitor.

assertStructType(config, 'config', 'PostProcessing');
assertStructType(D, 'diagnostics', 'PostProcessing');

%% Position density at final time
if config.monitor.posden || config.monitor.posden_size || config.output.plot_final_posden
    posden = diag(state_old.U);
    posden = posden(:);
end

if config.output.plot_final_posden
    f_of_x_save_fig({SD.x}, {posden}, ...
        {'Final position density, u_0(x,x)'}, '3_Final_posden', config, 'x');
end

if config.output.plot_final_solution
    xy_saveplot_fig(SD.x, SD.y, real(state_old.U), ...
        'Real part of u(x,y,T)', '3_Final_Re_u', config, 'x', 'y');
    xy_saveplot_fig(SD.x, SD.y, abs(state_old.U), ...
        'Modulus of u(x,y,T)', '3_Final_Abs_u', config, 'x', 'y');
end

%% Append final time to diagnostics time vector
D.tvec = [D.tvec, state_old.t];

%% Invariants at final time and drift computation
if config.output.do_invariants || config.monitor.invariants
    I = Invariants(CP, SD, state_old);
end

if config.output.do_invariants
    D.invariants.final = I;

    InvAbsErr = abs(D.invariants.initial - D.invariants.final);
    InvRelErr = abs(InvAbsErr ./ D.invariants.initial);

    D.invariants.dI = InvRelErr;

    InvTable = table(D.invariants.initial, D.invariants.final, InvAbsErr, InvRelErr, ...
        'VariableNames', {'I_j(0)', 'I_j(T)', 'Abs Err', 'Rel Err'});
    disp(InvTable);
end

if config.monitor.invariants
    D.invariants.history = [D.invariants.history, I];

    % Plot relative change of each invariant over time
    I0_rel = abs((abs(D.invariants.history(1,:)) - abs(D.invariants.history(1,1))) / D.invariants.history(1,1));
    I1_rel = abs((abs(D.invariants.history(2,:)) - abs(D.invariants.history(2,1))) / D.invariants.history(2,1));
    I2_rel = abs((abs(D.invariants.history(3,:)) - abs(D.invariants.history(3,1))) / D.invariants.history(3,1));
    I3_rel = abs((abs(D.invariants.history(4,:)) - abs(D.invariants.history(4,1))) / D.invariants.history(4,1));

    vec_cell   = {I0_rel, I1_rel, I2_rel, I3_rel};
    names_cell = {'I_0 (modulus of relative change in t)', ...
                  'I_1 (modulus of relative change in t)', ...
                  'I_2 (modulus of relative change in t)', ...
                  'I_3 (modulus of relative change in t)'};
    tvec_cell  = {D.tvec, D.tvec, D.tvec, D.tvec};

    f_of_x_save_fig(tvec_cell, vec_cell, names_cell, '2_invariants_in_t', config, 't');
end

%% Amplification factors at final time
if config.monitor.amplific_factor || config.output.do_amplific_factor
    [TAF, IAF] = AmplificationFactor(CP, SD, D, state_old);

    D.amplification.TAF = [D.amplification.TAF, TAF];
    D.amplification.TAF = max(D.amplification.TAF);

    D.amplification.IAF = [D.amplification.IAF, IAF];
    D.amplification.IAF = max(D.amplification.IAF);
end

%% Position density history plot
if config.monitor.posden
    D.posden.snapshots = [D.posden.snapshots, posden];
    xy_saveplot_fig(SD.x, D.tvec, D.posden.snapshots', ...
        'position density u(x,x,t)', '2_Posden_x_t', config, 'x', 't');
end

if config.monitor.posden_size
    D.posden.L2   = [D.posden.L2,   norm(posden) * sqrt(SD.dx)];
    D.posden.Linf = [D.posden.Linf, max(abs(posden))];

    vec_cell   = {D.posden.L2, D.posden.Linf};
    names_cell = {'L^2 norm of position density', 'L^\infty norm of position density'};
    tvec_cell  = {D.tvec, D.tvec};

    f_of_x_save_fig(tvec_cell, vec_cell, names_cell, '2_posden_size', config, 't');
end

%% Constraint error
if config.monitor.constr_error
    D.constr_error = [D.constr_error, 0];  % no meaningful value at final time (lost previous step)
    f_of_x_save_fig({D.tvec(2:end-1)}, {D.constr_error(2:end-1)}, ...
        {'Constraint error'}, '2_constr_err_t', config, 't');
end

%% Error vs exact solution
if config.flags.compare2exact
    ErrU   = state_old.U - CP.ExactSolution(SD.X, SD.Y, state_old.t);
    ErrPhi = state_old.Phi - (CP.ExactSolution(SD.X, SD.X, state_old.t_minus_half) ...
                            - CP.ExactSolution(SD.Y, SD.Y, state_old.t_minus_half));
    D.error.L2_U    = [D.error.L2_U,    norm(ErrU, 'fro') * SD.dx];
    D.error.Linf_U  = [D.error.Linf_U,  max(max(abs(ErrU)))];
    D.error.L2_Phi  = [D.error.L2_Phi,  norm(ErrPhi, 'fro') * SD.dx];
    D.error.Linf_Phi = [D.error.Linf_Phi, max(max(abs(ErrPhi)))];

    vec_cell   = {D.error.L2_U, D.error.Linf_U, D.error.L2_Phi, D.error.Linf_Phi};
    names_cell = {'L^2 error for U', 'L^\infty error for U', ...
                  'L^2 error for \Phi', 'L^\infty error for \Phi'};
    tvec_cell  = {D.tvec, D.tvec, D.tvec, D.tvec};

    if ~config.flags.series
        f_of_x_save_fig(tvec_cell, vec_cell, names_cell, '2_errors_in_t', config, 't');
    end

    Col_0 = ["Errors in U"; "Errors in Phi"];
    Col_1 = [D.error.L2_U(end); D.error.L2_Phi(end)];
    Col_2 = [D.error.Linf_U(end); D.error.Linf_Phi(end)];

    ErrTable = table(Col_1, Col_2, ...
        'VariableNames', {'L^2 errors', 'L^\infty errors'}, 'RowNames', Col_0);
    disp(ErrTable);

    if config.output.plot_final_error
        xy_saveplot_fig(SD.x, SD.y, ...
            real(state_old.U - CP.ExactSolution(SD.X, SD.Y, state_old.t)), ...
            'Error of u(x,y,T)', '4_Final_Error_u', config, 'x', 'y');
    end
end

end
