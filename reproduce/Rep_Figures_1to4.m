clc; close all; clear all

cd ..
init;

config = CreateConfig(1, 2, 'basic');  % volume=1, verbosity=2 (all plots)
config.flags.compare2exact       = 1;
config.problem.init_type         = 'advanced';
config.output.do_amplific_factor = 0;
config.output.plot_IC            = 0;
config.output.plot_IC_posden     = 0;
config.output.plot_final_solution = 0;
config.output.plot_final_error   = 1;
config.monitor.frequency         = 1;
config.monitor.posden            = 0;
config.monitor.posden_size       = 0;
config.monitor.invariants        = 1;
config.monitor.constr_error      = 1;
config.monitor.amplific_factor   = 0;

config

CP = SetupProblem(config)

dt = 0.001;
dx = 0.09;
T  = 1 * CP.Timescale;

[D, state_new] = ExecuteSingleRun(config, CP, dx, dt, T);
