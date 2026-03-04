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
cfg.L = 50;

cfg.plot_IC = 0;
cfg.plot_IC_posden = 0;

cfg.do_invariants = 1; % options are 0, 1. Controls whether to compute invariants of the continuous problem at initial and final time
                       % no good reason to turn it off...
cfg.do_amplific_factor = 1; % options are 0, 1. Controls whether to compute the total amplification factor from t=0 to t=T


cfg.keep_track_posden  = 0; % options are 0, 1. Controls whether to keep track of the position density throughout the computation
cfg.keep_track_posden_size = 0; % options are 0, 1. Controls whether to keep track of the L^2 and L^\infty norms of the position density throughout the computation
cfg.keep_track_invariants = 0; % options are 0, 1. Controls whether to keep track of the invariants I_j, j=1,2,3 throughout the computation
cfg.keep_track_constr_error = 0; % options are 0, 1. Controls whether to keep track of the constraint error throughout the computation
cfg.keep_track_amplific_factor = 0; % options are 0, 1. Controls whether to keep track of the total amplification factor throughout the computation
cfg.keep_track_frequency = 0; % every how many timesteps should we record the quantities we keep track of. Typically 10-40 for larger runs.
cfg.plot_final_posden = 0;


T=16;

dt=0.002
dx=0.12


N_mc = 20;


% Series Diagnostics
SeriesD.TAF = [];
SeriesD.IAF = [];
SeriesD.dt = [];
SeriesD.dx = [];
SeriesD.C = [];
SeriesD.dI0 = [];
SeriesD.dI1 = [];
SeriesD.dI2 = [];
SeriesD.dI3 = [];


filename = "outputs/" + cfg.job_tag  + "/SeriesD_" + ...
           string(datetime('now','Format','yyyy-MM-dd_HH-mm-ss'));



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


    SeriesD.TAF = [SeriesD.TAF CGD.total_amplific_factor];
    SeriesD.IAF = [SeriesD.IAF CGD.inhomogeneity_amplific_factor];

    SeriesD.dI0 = [SeriesD.dI0 CGD.dI0];
    SeriesD.dI1 = [SeriesD.dI1 CGD.dI1];
    SeriesD.dI2 = [SeriesD.dI2 CGD.dI2];
    SeriesD.dI3 = [SeriesD.dI3 CGD.dI3];

    save(filename,'SeriesD')

end




f1 = LaunchFigure(cfg);
plot(SeriesD.C,SeriesD.TAF,'b*','MarkerSize',8)
grid on
xlabel('C')
ylabel('Total Amp. Fact.')
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






f1 = LaunchFigure(cfg);
plot(SeriesD.C,SeriesD.IAF,'b*','MarkerSize',8)
grid on
xlabel('C')
ylabel('Inhom. Amp. Fact.')
title('Inhomogeneity amplification factor against intensity C')
set(gca, 'Fontsize', 18);
set(gca, 'XMinorTick', 'on', 'YMinorTick', 'on');


fig_tag = '5_inh_amp_fact';
pdf_filename = ['outputs/' cfg.job_tag '/' fig_tag '.pdf'];
fig_filename = ['outputs/' cfg.job_tag '/' fig_tag '.fig'];


exportgraphics(f1,pdf_filename,'ContentType','vector');

if cfg.save_figs
    saveas(f1,fig_filename)
end


close(f1)






f1 = LaunchFigure(cfg);
semilogy(SeriesD.C,SeriesD.dI0,'b*','MarkerSize',8)
grid on
hold on
semilogy(SeriesD.C,SeriesD.dI1,'k+','MarkerSize',8)
semilogy(SeriesD.C,SeriesD.dI2,'rs','MarkerSize',8)
semilogy(SeriesD.C,SeriesD.dI3,'^','MarkerSize',8)
xlabel('C')
ylabel('Invariants relative error (log)')
legend('\delta I_0','\delta I_1','\delta I_2','\delta I_3')
set(gca, 'Fontsize', 18);
set(gca, 'XMinorTick', 'on', 'YMinorTick', 'on');


fig_tag = '6_delta_invariants';
pdf_filename = ['outputs/' cfg.job_tag '/' fig_tag '.pdf'];
fig_filename = ['outputs/' cfg.job_tag '/' fig_tag '.fig'];


exportgraphics(f1,pdf_filename,'ContentType','vector');

if cfg.save_figs
    saveas(f1,fig_filename)
end


close(f1)






