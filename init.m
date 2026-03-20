function init


% create the local outputs folder if it doesn't exist
if ~exist('outputs', 'dir')
    mkdir('outputs');
end

% shuffle the rng seed with the clock
rng('shuffle');



%% set up paths, logging, and system diagnostics

% to get clean looking logs
try
    feature('HotLinks', 'off');
catch
end




% add paths and turn on logging
addpath('spatial_discretization')
addpath('common')
addpath('utilities')
addpath('problem_specific')
addpath('outputs')

% this would create one global log for all runs. In HPC it's unreadable
% hence it was moved in SetupCfg, in the outpath for each job
% diary outputs/everything.log


% delete any empty output subfolders leftover from previous times
% FolderCleanup('outputs/')



% switch profiling off, as profiling interferes with multi threading 
if strcmp(profile('status'), 'on')
    profile off
    disp('[init] Profiler was on before the script started — now turned off.');
else
%    disp('[preamble] Profiler was already off.');
end







disp('[init] Added paths, initialized diary...')


