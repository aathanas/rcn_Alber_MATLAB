function EOC_table = ReportEOC(config, CP, SeriesD, T)
%% Generate an experimental order of convergence (EOC) table.
%
%  EOC_table = ReportEOC(config, CP, SeriesD, T)
%
%  Detects whether dx or dt was refined (the other held fixed) and
%  computes EOC from the L^inf errors.

assertStructType(config, 'config', 'ReportEOC');
assertStructType(CP, 'continuous_problem', 'ReportEOC');
assertStructType(SeriesD, 'series_diagnostics', 'ReportEOC');

if sum(abs(diff(SeriesD.dx))) == 0
    % dx is constant → refinement in time
    EOC_U   = ExperimetalOrderConvergence(SeriesD.dt, SeriesD.LinfU);
    EOC_Phi = ExperimetalOrderConvergence(SeriesD.dt, SeriesD.LinfPhi);
    fprintf('[ReportEOC] Reporting EOC in time...\n');

elseif sum(abs(diff(SeriesD.dt))) == 0
    % dt is constant → refinement in space
    EOC_U   = ExperimetalOrderConvergence(SeriesD.dx, SeriesD.LinfU);
    EOC_Phi = ExperimetalOrderConvergence(SeriesD.dx, SeriesD.LinfPhi);
    fprintf('[ReportEOC] Reporting EOC in space...\n');

else
    error('[ReportEOC] Both dx and dt are varying — cannot determine refinement direction.');
end

header = sprintf('Results with %s initialization, %s, final time t=%g', ...
    config.problem.init_type, CP.problemname, T);
fprintf('%s\n', header);

EOC_table = table(SeriesD.dx', SeriesD.dt', SeriesD.LinfU', EOC_U, SeriesD.LinfPhi', EOC_Phi, ...
    'VariableNames', {'dx', 'dt', 'L^\inf error in U', 'EOC for U', 'L^\inf error in Phi', 'EOC for Phi'});

end
