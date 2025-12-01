function f1 = LaunchFigure(cfg)



if cfg.slurm_flag
    f1 = figure('Visible','off');
else
    f1 = figure;
end

set(gcf,'Theme','light')
set(gcf,'Units','normalized','Position',[0.1 0.1 0.6 0.6])






end