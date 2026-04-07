function f_of_x_save_fig(xcell, fcell, this_titlecell, fig_tag, config, x_lab)
%% Create and save a 1D line plot with one or more series.
%
%  f_of_x_save_fig(xcell, fcell, this_titlecell, fig_tag, config, x_lab)
%
%  Inputs:
%    xcell, fcell    — cell arrays of x and f(x) vectors.
%    this_titlecell  — cell array of legend labels (or title if single series).
%    fig_tag         — filename prefix for saved files.
%    config          — config struct (for output path, save flags).
%    x_lab           — x-axis label string.

f1 = LaunchFigure(config);

pdf_filename = fullfile(config.job.path, [fig_tag '.pdf']);
fig_filename = fullfile(config.job.path, [fig_tag '.fig']);

set(gcf, 'position', [0.1 0.4 0.8 0.6]);

for jj = 1:length(xcell)
    plot(xcell{jj}, fcell{jj}, 'LineWidth', 2, 'DisplayName', this_titlecell{jj});
    hold on
end

if length(this_titlecell) == 1
    title(this_titlecell{1});
else
    lgd = legend;
    set(lgd, 'Fontsize', 12, 'Interpreter', 'tex', 'Location', 'best');
end

xlabel(x_lab);
grid on
set(gca, 'Fontsize', 18);
set(gca, 'XMinorTick', 'on', 'YMinorTick', 'on');

if config.output.save_pdfs
    exportgraphics(f1, pdf_filename, 'ContentType', 'vector');
end

if config.output.save_figs
    saveas(f1, fig_filename);
end

close(f1);

end
