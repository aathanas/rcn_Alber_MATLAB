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

if ~cfg.compare2exact
    error('Exact solution needed to compute time order')
end



CP = SetupProblem(cfg)
% CP --> Continuous Problem
% contains the parameters that define the continuous problem on a finite
% computational domain, including the (continuous) initial condition 
% See detailed comments in SetupProblem for the fields of Parameters


T=0.01 * CP.Timescale % intended final time for the simulation


K = 3; % how many refinements for the time order

dt = 1.5 * CP.dt0;
dx = CP.dx0 / 2^(0.25*K+0.5); % assuming comparable baseline time and space error
                            % refine dx to provide negligible space error
                            % for the finest dt


% Series Diagnostics
SeriesD.dt = []; % dt used in each run
SeriesD.dx = []; % dt used in each run
SeriesD.L2U = []; % L2 error for U in each run
SeriesD.LinfU = []; % Linf error for U in each run
SeriesD.L2Phi = []; % L2 error for Phi in each run
SeriesD.LinfPhi = []; % Linf error for Phi in each run



for jj=1:K

    dt = dt / 2^0.5;

    % tweaking the discretization that will be used in this run

    






    [CGD,state_new] = ExecuteSingleRun(cfg,CP,dx,dt,T);


    SeriesD.dt = [SeriesD.dt dt]; % dt used in each run
    SeriesD.dx = [SeriesD.dx dx];
    SeriesD.L2U = [SeriesD.L2U max(CGD.L2_err_U)]; % L2 error for U in each run
    SeriesD.LinfU = [SeriesD.LinfU max(CGD.Linf_err_U)]; % Linf error for U in each run
    SeriesD.L2Phi = [SeriesD.L2Phi max(CGD.L2_err_Phi)]; % L2 error for Phi in each run
    SeriesD.LinfPhi = [SeriesD.LinfPhi max(CGD.Linf_err_Phi)]; % Linf error for Phi in each run

    

end



EOC_table = ReportTimeOrder(cfg,CP,SeriesD,T)


