clc; close all; clear all

%% set up job manually

init;
% load paths, cleanup empty output folders, run basic system diagnostics
% generates a timestamped job id

cfg = SetupCfg;
% cfg --> configuration
% creates a global config, with flags and preferences for what quantities 
% to compute, plot and save.
% See detailed comments in init for the fields of cfg

cfg.init_type = 'advanced';
% explicit control of initialization type

%%  Manually overwriting the cfg file to get the desired figures

cfg.compare2exact = 0;

cfg.MC_AF_run = 0; % this will create random IC
cfg.Fig9 = 1;

cfg.do_invariants = 1; % options are 0, 1. Controls whether to compute invariants of the continuous problem at initial and final time
                       % no good reason to turn it off...
cfg.do_amplific_factor = 1; % options are 0, 1. Controls whether to compute the total amplification factor from t=0 to t=T
cfg.plot_IC = 1; % options are 0, 1. Controls whether to plot the two-dimensional initial condition
cfg.plot_IC_posden = 0; % options are 0, 1. Controls whether to plot the initial position density, u0(x,x)
cfg.plot_final_solution = 0; % options are 0, 1. Controls whether to plot the two-dimensional solution at final time
cfg.plot_final_error = 0;
cfg.save_figs = 1; % options are 0, 1. Can result in very large outputs if many .fig files are saved, especially for 2D plots

% make sure we are comparing to exact solution for validation
cfg.keep_track_posden  = 1; % options are 0, 1. Controls whether to keep track of the position density throughout the computation
cfg.keep_track_posden_size = 1; % options are 0, 1. Controls whether to keep track of the L^2 and L^\infty norms of the position density throughout the computation
cfg.keep_track_invariants = 1; % options are 0, 1. Controls whether to keep track of the invariants I_j, j=1,2,3 throughout the computation
cfg.keep_track_constr_error = 1; % options are 0, 1. Controls whether to keep track of the constraint error throughout the computation
cfg.keep_track_amplific_factor = 1; % options are 0, 1. Controls whether to keep track of the total amplification factor throughout the computation
cfg.keep_track_frequency = 50; % every how many timesteps should we record the quantities we keep track of. Typically 10-40 for larger runs.

cfg.L = 50;

cfg.randomflag = 0;
%%


cfg
% print out cfg for the log



CP = SetupProblem(cfg)
% CP --> Continuous Problem
% contains the parameters that define the continuous problem on a finite
% computational domain, including the (continuous) initial condition 
% See detailed comments in SetupProblem for the fields of Parameters





dt=0.001
dx=0.09
% tweaking the discretization that will be used in this run

T = 10 % intended final time for the simulation






[CGD,state_new] = ExecuteSingleRun(cfg,CP,dx,dt,T);





