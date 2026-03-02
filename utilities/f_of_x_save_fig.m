function f_of_x_save_fig(xcell,fcell,this_titlecell,fig_tag,cfg,x_lab)
% this is intended to quickly and consistently save pcolor plots
% png format is appropriate



f1 = LaunchFigure(cfg);

pdf_filename = ['outputs/' cfg.job_tag '/' fig_tag '.pdf'];
fig_filename = ['outputs/' cfg.job_tag '/' fig_tag '.fig'];

set(gcf,'position',[0.1 0.4 0.8 0.6])

for jj=1:length(xcell)

    x=xcell{jj};
    f=fcell{jj};
    this_title = this_titlecell{jj};

    plot(x,f,'LineWidth',2,'DisplayName',this_title)
    hold on

end


if length(this_titlecell)==1
    title(this_title)
else
    lgd = legend;
    set(lgd,'Fontsize',12,'Interpreter','tex','Location','best')
end


xlabel(x_lab)
grid on
set(gca, 'Fontsize', 18);
set(gca, 'XMinorTick', 'on', 'YMinorTick', 'on');




exportgraphics(f1,pdf_filename,'ContentType','vector');


if cfg.save_figs
    saveas(f1,fig_filename)
end


close(f1)



end