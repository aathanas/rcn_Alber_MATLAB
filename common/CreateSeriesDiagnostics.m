function SeriesD = CreateSeriesDiagnostics(mode)
%% Create the series diagnostics struct for cross-run aggregation.
%
%  SeriesD = CreateSeriesDiagnostics('time_order')
%  SeriesD = CreateSeriesDiagnostics('space_order')
%  SeriesD = CreateSeriesDiagnostics('MC_AF')
%
%  Two shapes depending on mode:
%    Convergence (time_order / space_order):  dt, dx, L2U, LinfU, L2Phi, LinfPhi
%    Monte Carlo (MC_AF):                     TAF, IAF, dt, dx, C, dI0..dI3

SeriesD.type           = 'series_diagnostics';
SeriesD.schema_version = 1;

switch mode
    case {'time_order', 'space_order'}
        SeriesD.dt      = [];
        SeriesD.dx      = [];
        SeriesD.L2U     = [];
        SeriesD.LinfU   = [];
        SeriesD.L2Phi   = [];
        SeriesD.LinfPhi = [];

    case 'MC_AF'
        SeriesD.TAF = [];
        SeriesD.IAF = [];
        SeriesD.dt  = [];
        SeriesD.dx  = [];
        SeriesD.C   = [];
        SeriesD.dI0 = [];
        SeriesD.dI1 = [];
        SeriesD.dI2 = [];
        SeriesD.dI3 = [];

    otherwise
        error('[CreateSeriesDiagnostics] Unknown mode ''%s''.', mode);
end

end
