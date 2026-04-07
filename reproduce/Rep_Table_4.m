clc; close all; clear all

cd ..
init;

config = CreateConfig(1, 1, 'space_order');
config.problem.init_type = 'naive';

config

CP = SetupProblem(config)

T = 0.6;

K  = 4;
dt = 0.0005;
dx = 0.4;

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
