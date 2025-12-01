function cfg = SetupCfg
%% Create the cfg struct
% The confuguration struct cfg keeps track of flags and preferences in one
% place


% create new job tag
job_tag = datestr(now, 'dd-mmm-yyyy_HH-MM-SS'); 
cfg.job_tag = job_tag;

% create new output subfolder for the current job. 
try
    out_folder_name = ['outputs/' cfg.job_tag];
    mkdir(out_folder_name)
catch ME
    disp('Couldn''t set up the outputs folder')
    rethrow(ME)
end



cfg.slurm_flag = 1; % options are 1, 0. 
% If 1, it is assumed that the code is running in a non-interactive way 
% and opens no windows. This is safe for HPC clusters. Any plots are 
% saved directly in the outputs. If it is 0, plots open in figures, and 
% are also saved in the outputs.


cfg.series_flag = 0; % the default job is a single run. This is over-written for a series of runs

% ---------------------------------------------------------------------
cfg.compare2exact = 1; % options are 0, 1. 
% If 1, then this is a validation run against an exact solution that will
% be loaded. If it is 0, there are preset initial conditions that can be
% used or modified.
% ---------------------------------------------------------------------


cfg.init_type = 'advanced'; % options are 'naive', 'advanced'. Controls how Phi^{-1/2} is computed


%% All the options below concern diagnostics in single runs

% Outputs for t=0 and t=T (initial and final times for each run)-------
cfg.do_invariants = 1; % options are 0, 1. Controls whether to compute invariants of the continuous problem at initial and final time
                       % no good reason to turn it off...

cfg.do_amplific_factor = 0; % options are 0, 1. Controls whether to compute the total amplification factor from t=0 to t=T

cfg.plot_IC = 0; % options are 0, 1. Controls whether to plot the two-dimensional initial condition

cfg.plot_IC_posden = 0; % options are 0, 1. Controls whether to plot the initial position density, u0(x,x)

cfg.plot_final_solution = 0; % options are 0, 1. Controls whether to plot the two-dimensional solution at final time

cfg.plot_final_posden = 0; % always one by deafult

cfg.save_figs = 0; % options are 0, 1. Can result in very large outputs if many .fig files are saved, especially for 2D plots
% ---------------------------------------------------------------------


% Diagnostics to keep track of over t\in[0,T] during each run ----------
cfg.keep_track_posden  = 0; % options are 0, 1. Controls whether to keep track of the position density throughout the computation

cfg.keep_track_posden_size = 0; % options are 0, 1. Controls whether to keep track of the L^2 and L^\infty norms of the position density throughout the computation

cfg.keep_track_invariants = 0; % options are 0, 1. Controls whether to keep track of the invariants I_j, j=1,2,3 throughout the computation

cfg.keep_track_constr_error = 0; % options are 0, 1. Controls whether to keep track of the constraint error throughout the computation

cfg.keep_track_amplific_factor = 0; % options are 0, 1. Controls whether to keep track of the total amplification factor throughout the computation

cfg.keep_track_frequency = 0; % every how many timesteps should we record the quantities we keep track of. Typically 10-40 for larger runs.
% ---------------------------------------------------------------------


disp('[init] Set up cfg struct...')

end