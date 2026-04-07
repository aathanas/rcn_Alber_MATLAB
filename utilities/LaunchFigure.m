function f1 = LaunchFigure(config)
%% Create a figure with consistent styling.
%
%  f1 = LaunchFigure(config)
%
%  If config.flags.interactive == 0, the figure is created off-screen
%  (safe for HPC).  Otherwise a visible window opens.

if ~config.flags.interactive
    f1 = figure('Visible', 'off');
else
    f1 = figure;
end

set(gcf, 'Units', 'normalized', 'Position', config.style.FigurePosition);

end
