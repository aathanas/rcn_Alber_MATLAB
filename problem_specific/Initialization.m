function state = Initialization(config, CP, SD, dt, T)
%% Create the initial solver state for the (nonlinear) Alber equation.
%
%  state = Initialization(config, CP, SD, dt, T)
%
%  Computes u(x,y,0) from CP.IC and initializes Phi^{-1/2} according
%  to config.problem.init_type:
%    'naive'    — Phi from u at t=0 (no backward step)
%    'advanced' — half-step backward to compute Phi at t = -dt/2
%    'exact'    — evaluate CP.ExactSolution at t = -dt/2

assertStructType(config, 'config', 'Initialization');
assertStructType(CP, 'continuous_problem', 'Initialization');
assertStructType(SD, 'spatial_discretization', 'Initialization');

%% Naive initialization (always computed as baseline)
uOld   = CP.IC(SD.X, SD.Y);
PhiOld = Phi_from_u(uOld);

% Temporary state needed for the advanced backward step
state.U   = uOld + SD.GammaMatrix;
state.Phi = PhiOld;
state.t   = 0;

%% Advanced or exact initialization
if strcmp(config.problem.init_type, 'advanced')
    fprintf('[Initialization] Performing advanced initialization step...\n');
    tic;
    staux     = timestep(CP, -dt/2, state, SD);
    step_time = toc;

    fprintf('[Initialization] ~%.2f s per timestep.\n', step_time);
    fprintf('[Initialization] Estimated ~%d minutes for this run.\n', ...
        ceil(T * step_time / (dt * 60)));

    PhiOld = Phi_from_u(staux.U);

elseif strcmp(config.problem.init_type, 'exact')
    fprintf('[Initialization] Performing exact initialization step...\n');

    Uaux   = CP.ExactSolution(SD.X, SD.Y, -dt/2);
    PhiOld = Phi_from_u(Uaux);
end

%% Assemble final initial state
state.type         = 'solver_state';
state.U            = uOld;
state.Phi          = PhiOld;
state.t            = 0;
state.t_minus_half = -dt/2;

end
