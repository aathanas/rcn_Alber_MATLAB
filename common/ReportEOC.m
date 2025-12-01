function EOC_table = ReportTimeOrder(cfg,CP,SeriesD,T)


if sum(abs(diff(SeriesD.dx))) == 0

    EOC_time_U =  ExperimetalOrderConvergence(SeriesD.dt,SeriesD.LinfU);

    EOC_time_Phi =  ExperimetalOrderConvergence(SeriesD.dt,SeriesD.LinfPhi);
    disp('Reporting EOC in time...')

elseif sum(abs(diff(SeriesD.dt))) == 0

    EOC_time_U =  ExperimetalOrderConvergence(SeriesD.dx,SeriesD.LinfU);

    EOC_time_Phi =  ExperimetalOrderConvergence(SeriesD.dx,SeriesD.LinfPhi);

    disp('Reporting EOC in space...')

else
    error('Not sure how to report EOC')

end


header=['Results with ' cfg.init_type ' initialization, ' CP.problemname ', final time t=' num2str(T)];

VariableNames = { 'dx', 'dt',  'U L^inf error', 'Phi L^inf error', 'compute time', 'R EOC', 'Phi EOC'};

EOC_table = table(SeriesD.dx',SeriesD.dt',SeriesD.LinfU',EOC_time_U,SeriesD.LinfPhi',EOC_time_Phi,'VariableNames',{'dx','dt','L^\inf error in U','EOC for U','L^\inf error in Phi','EOC for Phi'});


