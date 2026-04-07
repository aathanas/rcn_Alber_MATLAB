%% Figure 8: Comparison of nonlinear and linearized solver.
%  Plots L2 and Linf norms of the inhomogeneity (position density)
%  for both the fully nonlinear and linearized Alber equation,
%  using the same problem as Figure 7 (strongly unstable, C=1.9).

clc; close all; clear all

cd ..
init;

%% Common setup (same as Rep_Figure_7)
config = CreateConfig(1, 1, 'basic');
config.flags.compare2exact       = 0;
config.problem.reproduce         = 'Fig7';
config.problem.init_type         = 'advanced';
config.problem.L                 = 50;
config.flags.randomflag          = 0;
config.output.do_invariants      = 0;
config.output.do_amplific_factor = 0;
config.output.plot_IC            = 0;
config.output.plot_final_posden  = 0;
config.monitor.frequency         = 50;
config.monitor.posden            = 0;
config.monitor.posden_size       = 1;
config.monitor.invariants        = 0;
config.monitor.constr_error      = 0;
config.monitor.amplific_factor   = 0;

CP = SetupProblem(config);

dt = 0.001;
dx = 0.09;
T  = 10;

%% Run nonlinear solver
fprintf('\n========== Nonlinear run ==========\n\n');
[D_nl, ~] = ExecuteSingleRun(config, CP, dx, dt, T);

%% Run linearized solver
fprintf('\n========== Linearized run ==========\n\n');
[D_lin, ~] = ExecuteSingleRun_lin(config, CP, dx, dt, T);

%% Plot
f1 = LaunchFigure(config);

% Nonlinear: solid lines with markers
N_nl  = length(D_nl.tvec);
mk_nl = round(linspace(1, N_nl, min(15, N_nl)));  % sparse marker indices

plot(D_nl.tvec, D_nl.posden.L2, 'b-', 'LineWidth', 2, 'DisplayName', 'Nonlinear L^2 norm');
hold on
plot(D_nl.tvec(mk_nl), D_nl.posden.L2(mk_nl), 'b^', 'MarkerSize', 7, 'HandleVisibility', 'off');

plot(D_nl.tvec, D_nl.posden.Linf, 'r-', 'LineWidth', 2, 'DisplayName', 'Nonlinear L^\infty norm');
plot(D_nl.tvec(mk_nl), D_nl.posden.Linf(mk_nl), 'rs', 'MarkerSize', 7, 'HandleVisibility', 'off');

% Linearized: dashed/dotted lines with crosses
N_lin  = length(D_lin.tvec);
mk_lin = round(linspace(1, N_lin, min(15, N_lin)));

plot(D_lin.tvec, D_lin.posden.L2, 'b--', 'LineWidth', 2, 'DisplayName', 'Linearized L^2 norm');
plot(D_lin.tvec(mk_lin), D_lin.posden.L2(mk_lin), 'bx', 'MarkerSize', 7, 'HandleVisibility', 'off');

plot(D_lin.tvec, D_lin.posden.Linf, 'r:', 'LineWidth', 2, 'DisplayName', 'Linearized L^\infty norm');
plot(D_lin.tvec(mk_lin), D_lin.posden.Linf(mk_lin), 'rx', 'MarkerSize', 7, 'HandleVisibility', 'off');

grid on
xlabel('t');
ylabel('Norm of position density');
lgd = legend('Location', 'best');
set(lgd, 'Fontsize', 12, 'Interpreter', 'tex');
set(gca, 'Fontsize', 18, 'XMinorTick', 'on', 'YMinorTick', 'on');

fig_tag = 'Fig8_nonlin_vs_lin';
exportgraphics(f1, fullfile(config.job.path, [fig_tag '.pdf']), 'ContentType', 'vector');
if config.output.save_figs
    saveas(f1, fullfile(config.job.path, [fig_tag '.fig']));
end
close(f1);

fprintf('\n========== Figure 8 complete ==========\n');
