clc; close all; clear all

tic

cd ..
init;

config = CreateConfig(1, 1, 'time_order');
config.problem.init_type = 'advanced';

config

CP = SetupProblem(config)

T = 0.6;

K  = 4;
dx = 0.04;
dt = 0.03;

SeriesD = CreateSeriesDiagnostics('time_order');

for jj = 1:K

    [D, state_new] = ExecuteSingleRun(config, CP, dx, dt, T);

    SeriesD.dt      = [SeriesD.dt,      dt];
    SeriesD.dx      = [SeriesD.dx,      dx];
    SeriesD.L2U     = [SeriesD.L2U,     max(D.error.L2_U)];
    SeriesD.LinfU   = [SeriesD.LinfU,   max(D.error.Linf_U)];
    SeriesD.L2Phi   = [SeriesD.L2Phi,   max(D.error.L2_Phi)];
    SeriesD.LinfPhi = [SeriesD.LinfPhi, max(D.error.Linf_Phi)];

    dt = dt / 2^0.5;
end

EOC_table = ReportEOC(config, CP, SeriesD, T)

fprintf('Total computation time for time EOC run: %s\n', DisplayTime(toc));
