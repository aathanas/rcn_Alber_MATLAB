clc; close all; clear all

cd ..
init;

config = CreateConfig(1, 1, 'basic');
config.flags.compare2exact       = 0;
config.problem.reproduce         = 'Fig7';
config.problem.init_type         = 'advanced';
config.problem.L                 = 50;
config.flags.randomflag          = 0;
config.output.do_invariants      = 1;
config.output.do_amplific_factor = 1;
config.output.plot_IC            = 1;
config.output.plot_IC_posden     = 0;
config.output.plot_final_solution = 0;
config.output.plot_final_error   = 0;
config.monitor.frequency         = 50;
config.monitor.posden            = 1;
config.monitor.posden_size       = 1;
config.monitor.invariants        = 1;
config.monitor.constr_error      = 1;
config.monitor.amplific_factor   = 1;

config

CP = SetupProblem(config)

dt = 0.001;
dx = 0.09;
T  = 20;

[D, state_new] = ExecuteSingleRun(config, CP, dx, dt, T);
