function xy_saveplot_fig(x, y, f, this_title, fig_tag, config, x_lab, y_lab)
%% Create and save a 2D pcolor plot.
%
%  xy_saveplot_fig(x, y, f, this_title, fig_tag, config, x_lab, y_lab)

f1 = LaunchFigure(config);

png_filename = fullfile(config.job.path, [fig_tag '.png']);
fig_filename = fullfile(config.job.path, [fig_tag '.fig']);

pcolor(x, y, f);
shading interp
title(this_title);
xlabel(x_lab);
ylabel(y_lab);
colorbar
set(gca, 'Fontsize', 18);
set(gca, 'XMinorTick', 'on', 'YMinorTick', 'on');

exportgraphics(f1, png_filename, 'Resolution', 200);

if config.output.save_figs
    saveas(f1, fig_filename);
end

close(f1);

end
