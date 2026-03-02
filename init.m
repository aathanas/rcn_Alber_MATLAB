function init

%% set up paths, logging, and system diagnostics

% to get clean looking logs
try
    feature('HotLinks', 'off');
catch ME
end


% add paths and turn on logging
addpath('spatial_discretization')
addpath('common')
addpath('utilities')
addpath('problem_specific')
addpath('tests')
addpath('outputs')

diary outputs/everything.log


% delete any empty output subfolders leftover from previous times
FolderCleanup('outputs/')



% switch profiling off, as profiling interferes with multi threading 
if strcmp(profile('status'), 'on')
    profile off
    disp('[init] Profiler was on before the script started — now turned off.');
else
%    disp('[preamble] Profiler was already off.');
end



% timestamp of starting up the job
disp(['[init] ' char(datetime('now')) ]);


% print out the name of the computer we are working on for the log
try
    hostname = getHostname;
    if ~isempty(hostname)
        disp(['[init] Working on ' getHostname ]);
    end
catch ME
    disp('[init] Couldn''t get hostname...');
end


% print out cores info
disp('[init] Processors info: ')
feature('numCores');

% print out blas info (relates to multi-thread execution of linear algebra)
blas_info = version('-blas');
disp(['[init] BLAS version: '  blas_info ]) 




disp('[init] Added paths, initialized diary...')


