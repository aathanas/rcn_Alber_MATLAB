clc; close all; clear all

%% set up job manually

init;
% load paths, cleanup empty output folders, run basic system diagnostics
% generates a timestamped job id

cfg = SetupCfg;
% cfg --> configuration
% creates a global config, with flags and preferences for what quantities 
% to compute, plot and save.
% See detailed comments for the fields of cfg

cfg.compare2exact = 0;
% this will disable the comparison to exact solution, and will go the
% default problem in the end of SetupProblem.m ,below

cfg
% print out cfg for the log



CP = SetupProblem(cfg)
% CP --> Continuous Problem
% contains the parameters that define the continuous problem on a finite
% computational domain, including the (continuous) initial condition 
% See detailed comments in SetupProblem for the fields of Parameters




dt=0.002
dx=0.12
% tweaking the discretization that will be used in this run

T=0.01 * CP.Timescale % intended final time for the simulation






[CGD,state_new] = ExecuteSingleRun(cfg,CP,dx,dt,T);





