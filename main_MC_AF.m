clc; close all; clear all

init;

config = CreateConfig(1, 1, 'MC_AF');
config.problem.L = 50;

config

T    = 16;
dt   = 0.002;
dx   = 0.12;
N_mc = 20;

SeriesD = CreateSeriesDiagnostics('MC_AF');

filename = fullfile(config.job.path, ...
    ['SeriesD_' char(datetime('now', 'Format', 'yyyy-MM-dd_HH-mm-ss'))]);

for jj = 1:N_mc

    CP = SetupProblem(config)

    SeriesD.C  = [SeriesD.C,  CP.SpectrumIntensity];
    SeriesD.dt = [SeriesD.dt, dt];
    SeriesD.dx = [SeriesD.dx, dx];

    [D, state_new] = ExecuteSingleRun(config, CP, dx, dt, T);

    SeriesD.TAF = [SeriesD.TAF, D.amplification.TAF];
    SeriesD.IAF = [SeriesD.IAF, D.amplification.IAF];

    SeriesD.dI0 = [SeriesD.dI0, D.invariants.dI(1)];
    SeriesD.dI1 = [SeriesD.dI1, D.invariants.dI(2)];
    SeriesD.dI2 = [SeriesD.dI2, D.invariants.dI(3)];
    SeriesD.dI3 = [SeriesD.dI3, D.invariants.dI(4)];

    save(filename, 'SeriesD');

end

%% Plot: Total amplification factor vs C
f1 = LaunchFigure(config);
plot(SeriesD.C, SeriesD.TAF, 'b*', 'MarkerSize', 8);
grid on
xlabel('C'); ylabel('Total Amp. Fact.');
title('Total amplification factor against intensity C');
set(gca, 'Fontsize', 18, 'XMinorTick', 'on', 'YMinorTick', 'on');
exportgraphics(f1, fullfile(config.job.path, '4_amp_fact.pdf'), 'ContentType', 'vector');
if config.output.save_figs
    saveas(f1, fullfile(config.job.path, '4_amp_fact.fig'));
end
close(f1);

%% Plot: Inhomogeneity amplification factor vs C
f1 = LaunchFigure(config);
plot(SeriesD.C, SeriesD.IAF, 'b*', 'MarkerSize', 8);
grid on
xlabel('C'); ylabel('Inhom. Amp. Fact.');
title('Inhomogeneity amplification factor against intensity C');
set(gca, 'Fontsize', 18, 'XMinorTick', 'on', 'YMinorTick', 'on');
exportgraphics(f1, fullfile(config.job.path, '5_inh_amp_fact.pdf'), 'ContentType', 'vector');
if config.output.save_figs
    saveas(f1, fullfile(config.job.path, '5_inh_amp_fact.fig'));
end
close(f1);

%% Plot: Invariant drift vs C
f1 = LaunchFigure(config);
semilogy(SeriesD.C, SeriesD.dI0, 'b*', 'MarkerSize', 8); hold on
semilogy(SeriesD.C, SeriesD.dI1, 'k+', 'MarkerSize', 8);
semilogy(SeriesD.C, SeriesD.dI2, 'rs', 'MarkerSize', 8);
semilogy(SeriesD.C, SeriesD.dI3, '^',  'MarkerSize', 8);
grid on
xlabel('C'); ylabel('Invariants relative error (log)');
legend('\delta I_0', '\delta I_1', '\delta I_2', '\delta I_3');
set(gca, 'Fontsize', 18, 'XMinorTick', 'on', 'YMinorTick', 'on');
exportgraphics(f1, fullfile(config.job.path, '6_delta_invariants.pdf'), 'ContentType', 'vector');
if config.output.save_figs
    saveas(f1, fullfile(config.job.path, '6_delta_invariants.fig'));
end
close(f1);
