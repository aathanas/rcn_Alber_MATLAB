function [D, state_new] = ExecuteSingleRun(config, CP, dx, dt, T)
%% Execute a single simulation run of the (nonlinear) Alber equation.
%
%  [D, state_new] = ExecuteSingleRun(config, CP, dx, dt, T)
%
%  Builds spatial discretization, initializes state, runs the time loop,
%  and returns diagnostics D and the final state.

assertStructType(config, 'config', 'ExecuteSingleRun');
assertStructType(CP, 'continuous_problem', 'ExecuteSingleRun');

SD = CreateSpatialDiscretization(CP, dx);

state_old = Initialization(config, CP, SD, dt, T);

D = PreProcessing(config, CP, SD, state_old);

%% Main time loop
tcount = 0;
tic;
while state_old.t < T

    tcount = tcount + 1;

    state_new = timestep(CP, dt, state_old, SD);

    if (mod(tcount, config.monitor.frequency) == 0) && config.monitor.frequency > 0
        D = UpdateDiagnostics(config, CP, SD, state_old, state_new, D);
    end

    state_old = state_new;

end
main_comp_time = toc;
D.runtime.comp_time = main_comp_time;

fprintf('[ExecuteSingleRun] Main time loop complete after %.2f minutes.\n', ...
    main_comp_time / 60);

D = PostProcessing(config, CP, SD, state_old, D);

end
