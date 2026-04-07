clc; close all; clear all

init;

config = CreateConfig(1, 1, 'space_order');
% config.problem.init_type = 'naive';
config.problem.init_type = 'advanced';

config

CP = SetupProblem(config)

T = 0.6;

K  = 4;      % number of refinements
dt = 0.0005; % fixed (fine enough to isolate space error)
dx = 0.4;    % will be refined

SeriesD = CreateSeriesDiagnostics('space_order');

for jj = 1:K

    [D, state_new] = ExecuteSingleRun(config, CP, dx, dt, T);

    SeriesD.dt      = [SeriesD.dt,      dt];
    SeriesD.dx      = [SeriesD.dx,      dx];
    SeriesD.L2U     = [SeriesD.L2U,     max(D.error.L2_U)];
    SeriesD.LinfU   = [SeriesD.LinfU,   max(D.error.Linf_U)];
    SeriesD.L2Phi   = [SeriesD.L2Phi,   max(D.error.L2_Phi)];
    SeriesD.LinfPhi = [SeriesD.LinfPhi, max(D.error.Linf_Phi)];

    dx = dx / 2^0.25;

end

EOC_table = ReportEOC(config, CP, SeriesD, T)
