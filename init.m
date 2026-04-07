function init
%% Silent setup: paths, output folder, rng.
%  No logging here — diary is started in CreateConfig after the job
%  subfolder is created, so that all output goes into the job log.

% Clean looking logs
try
    feature('HotLinks', 'off');
catch
end

% Add paths
addpath('spatial_discretization')
addpath('common')
addpath('utilities')
addpath('problem_specific')
addpath('outputs')

% Create the local outputs folder if it doesn't exist
if ~exist('outputs', 'dir')
    mkdir('outputs');
end

% Switch profiling off — profiling interferes with multi-threading
if strcmp(profile('status'), 'on')
    profile off
    disp('[init] Profiler was on — now turned off.');
end

% Shuffle the rng seed with the clock
rng('shuffle');

end
