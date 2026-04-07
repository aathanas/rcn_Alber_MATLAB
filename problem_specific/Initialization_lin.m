function state = Initialization_lin(config, CP, SD, dt, T)
%% Create the initial solver state for the linearized Alber equation.
%
%  state = Initialization_lin(config, CP, SD, dt, T)
%
%  Same as Initialization, but uses timestep_lin for the advanced
%  backward step.  The 'exact' init_type is not supported here
%  (the linearized equation has no known exact solution).

assertStructType(config, 'config', 'Initialization_lin');
assertStructType(CP, 'continuous_problem', 'Initialization_lin');
assertStructType(SD, 'spatial_discretization', 'Initialization_lin');

%% Naive initialization (always computed as baseline)
uOld   = CP.IC(SD.X, SD.Y);
PhiOld = Phi_from_u(uOld);

% Temporary state needed for the advanced backward step
state.U   = uOld + SD.GammaMatrix;
state.Phi = PhiOld;
state.t   = 0;

%% Advanced initialization
if strcmp(config.problem.init_type, 'advanced')
    fprintf('[Initialization_lin] Performing advanced initialization step...\n');
    tic;
    staux     = timestep_lin(CP, -dt/2, state, SD);
    step_time = toc;

    fprintf('[Initialization_lin] ~%.2f s per timestep.\n', step_time);
    fprintf('[Initialization_lin] Estimated ~%d minutes for this run.\n', ...
        ceil(T * step_time / (dt * 60)));

    PhiOld = Phi_from_u(staux.U);
end

%% Assemble final initial state
state.type         = 'solver_state';
state.U            = uOld;
state.Phi          = PhiOld;
state.t            = 0;
state.t_minus_half = -dt/2;

end
