function config = CreateConfig(volume, verbosity, mode)
%% Create the config struct with three master knobs.
%
%  config = CreateConfig()                     % defaults: volume=1, verbosity=1, mode='basic'
%  config = CreateConfig(volume, verbosity)    % explicit volume/verbosity, mode='basic'
%  config = CreateConfig(volume, verbosity, mode)
%
%  Master knobs:
%    volume     (0/1/2) — file saving.   0=none, 1=per-flag, 2=everything.
%    verbosity  (0/1/2) — plots/console. 0=silent, 1=standard, 2=all.
%    mode       string  — workflow type.  Cascades series, compare2exact, tracking.
%                         'basic'       single run, no exact comparison
%                         'time_order'  convergence in time (series, compare2exact)
%                         'space_order' convergence in space (series, compare2exact)
%                         'MC_AF'       Monte Carlo amplification factor study

%% Defaults
if nargin < 1, volume    = 1;       end
if nargin < 2, verbosity = 1;       end
if nargin < 3, mode      = 'basic'; end

%% Validate master knobs
assert(ismember(volume, [0 1 2]),    '[CreateConfig] volume must be 0, 1, or 2.');
assert(ismember(verbosity, [0 1 2]), '[CreateConfig] verbosity must be 0, 1, or 2.');
valid_modes = {'basic', 'time_order', 'space_order', 'MC_AF'};
assert(ismember(mode, valid_modes),  '[CreateConfig] mode must be one of: basic, time_order, space_order, MC_AF.');

%% Type tag
config.type           = 'config';
config.schema_version = 1;

%% Preset (master knobs stored for reference)
config.preset.volume    = volume;
config.preset.verbosity = verbosity;
config.preset.mode      = mode;

%% Job identity
config.job.tag         = datestr(now, 'dd-mmm-yyyy_HH-MM-SS-FFF');
config.job.path        = fullfile('outputs', config.job.tag);
config.job.launch_time = char(datetime('now'));

try
    mkdir(config.job.path);
catch ME
    disp('[CreateConfig] Could not create output folder.');
    rethrow(ME);
end

diary(fullfile(config.job.path, 'everything.log'));

% System info for the log
fprintf('[CreateConfig] %s\n', config.job.launch_time);

try
    config.job.host = getHostname();
    if ~isempty(config.job.host)
        fprintf('[CreateConfig] Working on %s\n', config.job.host);
    end
catch
    config.job.host = '';
    disp('[CreateConfig] Could not get hostname.');
end

fprintf('[CreateConfig] Processors info:\n');
config.job.cores = feature('numCores');

config.job.blas = version('-blas');
fprintf('[CreateConfig] BLAS version: %s\n', config.job.blas);

config.job.cpu = '';  % placeholder for future use

%% Flags — feature toggles
config.flags.interactive   = 0;   % 0=batch (no figure windows), 1=interactive
config.flags.series        = 0;   % 0=single run, 1=series (driven by mode)
config.flags.compare2exact = 0;   % 0=preset problem, 1=validation vs exact solution
config.flags.randomflag    = 1;   % 1=randomize inhomogeneity coefficients

%% Problem parameters
config.problem.reproduce = 'none';       % 'none', 'Fig6', 'Fig7', 'MC_AF'
config.problem.init_type = 'advanced';   % 'naive', 'advanced', 'exact'
config.problem.L         = 24;           % domain half-width

%% Output — endpoint computations and plots (gated by verbosity and volume)
config.output.do_invariants       = 1;
config.output.do_amplific_factor  = 1;
config.output.plot_IC             = 0;
config.output.plot_IC_posden      = 0;
config.output.plot_final_solution = 0;
config.output.plot_final_posden   = 1;
config.output.plot_final_error    = 0;
config.output.save_figs           = 1;
config.output.save_pdfs           = 1;

%% Monitor — mid-run tracking (gated by verbosity)
config.monitor.frequency       = 0;  % 0=off, N=every Nth timestep
config.monitor.posden          = 1;
config.monitor.posden_size     = 0;
config.monitor.invariants      = 1;
config.monitor.constr_error    = 0;
config.monitor.amplific_factor = 1;

%% Style
config.style.FigurePosition = [0.1 0.1 0.6 0.6];

%% ===== Mode cascade =====
% Mode drives workflow-level defaults

switch mode
    case 'basic'
        config.flags.series        = 0;
        config.flags.compare2exact = 0;

    case {'time_order', 'space_order'}
        config.flags.series        = 1;
        config.flags.compare2exact = 1;
        config.monitor.frequency   = 1;  % record every timestep for convergence

    case 'MC_AF'
        config.flags.series        = 1;
        config.flags.compare2exact = 0;
        config.problem.reproduce   = 'MC_AF';
        config.output.do_amplific_factor = 1;
        % Minimal tracking for MC runs
        config.monitor.frequency       = 0;
        config.monitor.posden          = 0;
        config.monitor.posden_size     = 0;
        config.monitor.invariants      = 0;
        config.monitor.constr_error    = 0;
        config.monitor.amplific_factor = 0;
        config.output.plot_IC          = 0;
        config.output.plot_IC_posden   = 0;
        config.output.plot_final_posden = 0;
end

%% ===== Verbosity cascade =====

if verbosity == 0
    % Silent: no plots, no mid-run monitoring
    config.output.plot_IC             = 0;
    config.output.plot_IC_posden      = 0;
    config.output.plot_final_solution = 0;
    config.output.plot_final_posden   = 0;
    config.output.plot_final_error    = 0;
    config.monitor.frequency          = 0;
elseif verbosity == 2
    % Verbose: enable all plots and monitoring
    config.output.plot_IC             = 1;
    config.output.plot_IC_posden      = 1;
    config.output.plot_final_solution = 1;
    config.output.plot_final_posden   = 1;
    config.monitor.posden             = 1;
    config.monitor.posden_size        = 1;
    config.monitor.invariants         = 1;
    config.monitor.constr_error       = 1;
    config.monitor.amplific_factor    = 1;
end

%% ===== Volume cascade =====

if volume == 0
    config.output.save_figs = 0;
    config.output.save_pdfs = 0;
elseif volume == 2
    config.output.save_figs = 1;
    config.output.save_pdfs = 1;
end

%% ===== Cross-cutting adjustments =====

% Cannot plot error without exact solution
if ~config.flags.compare2exact
    config.output.plot_final_error = 0;
end

% Monitoring implies endpoint computation
if config.monitor.invariants
    config.output.do_invariants = 1;
end
if config.monitor.amplific_factor
    config.output.do_amplific_factor = 1;
end

fprintf('[CreateConfig] mode=''%s'', volume=%d, verbosity=%d\n', mode, volume, verbosity);

end
