clc; close all; clear all

%% set up job manually

init;
% load paths, cleanup empty output folders, run basic system diagnostics
% generates a timestamped job id

cfg = SetupCfg
% cfg --> configuration
% creates a global config, with flags and preferences for what quantities 
% to compute, plot and save.
% See detailed comments in init for the fields of cfg





CP = SetupProblem(cfg)
% CP --> Continuous Problem
% contains the parameters that define the continuous problem on a finite
% computational domain, including the (continuous) initial condition 
% See detailed comments in SetupProblem for the fields of Parameters




dt=0.02
dx=0.155
% tweaking the discretization that will be used in this run

T=0.05 * CP.Timescale % intended final time for the simulation






[CGD,state_new] = ExecuteSingleRun(cfg,CP,dx,dt,T);





