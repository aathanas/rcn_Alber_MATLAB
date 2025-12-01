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


cfg.MC_AF_run = 1;
cfg.compare2exact = 0;
cfg.do_amplific_factor = 1;


T=10;

dt = 0.01;
dx = 0.1;


N_mc = 20;


% Series Diagnostics
SeriesD.AF = [];
SeriesD.dt = [];
SeriesD.dx = [];
SeriesD.C = [];


for jj=1:N_mc


    CP = SetupProblem(cfg)
    % CP --> Continuous Problem
    % contains the parameters that define the continuous problem on a finite
    % computational domain, including the (continuous) initial condition
    % See detailed comments in SetupProblem for the fields of Parameters


    SeriesD.C = [SeriesD.C CP.SpectrumIntensity];
    SeriesD.dt = [SeriesD.dt dt]; % dt used in each run
    SeriesD.dx = [SeriesD.dx dx];




    [CGD,state_new] = ExecuteSingleRun(cfg,CP,dx,dt,T);


    SeriesD.AF = [SeriesD.AF CGD.amplific_factor];

end




f1 = LaunchFigure(cfg);
plot(SeriesD.C,SeriesD.AF,'b*','MarkerSize',8)
grid on
xlabel('C')
ylabel('Amp. Fact.')
title('Total amplification factor against intensity C')
set(gca, 'Fontsize', 18);
set(gca, 'XMinorTick', 'on', 'YMinorTick', 'on');


fig_tag = '4_amp_fact';
pdf_filename = ['outputs/' cfg.job_tag '/' fig_tag '.pdf'];
fig_filename = ['outputs/' cfg.job_tag '/' fig_tag '.fig'];


exportgraphics(f1,pdf_filename,'ContentType','vector');

if cfg.save_figs
    saveas(f1,fig_filename)
end


close(f1)

