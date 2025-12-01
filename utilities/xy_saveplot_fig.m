function xy_saveplot_fig(x,y,f,this_title,fig_tag,cfg,x_lab,y_lab)
% this is intended to quickly and consistently save pcolor plots
% png format is appropriate

f1 = LaunchFigure(cfg);

png_filename = ['outputs/' cfg.job_tag '/' fig_tag '.png'];
fig_filename = ['outputs/' cfg.job_tag '/' fig_tag '.fig'];

pcolor(x,y,f);
shading interp
title(this_title)
xlabel(x_lab)
ylabel(y_lab)
colorbar
set(gca, 'Fontsize', 18);
set(gca, 'XMinorTick', 'on', 'YMinorTick', 'on');

exportgraphics(f1,png_filename,"Resolution",200);


if cfg.save_figs
    saveas(f1,fig_filename)
end


close(f1)



end