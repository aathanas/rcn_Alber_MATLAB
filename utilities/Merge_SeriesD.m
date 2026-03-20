function SeriesD_all = Merge_SeriesD(SeriesD,SeriesD_all)


SeriesD_all.TAF = [SeriesD_all.TAF SeriesD.TAF];
SeriesD_all.IAF = [SeriesD_all.IAF SeriesD.IAF];
SeriesD_all.dt = [SeriesD_all.dt SeriesD.dt];
SeriesD_all.dx = [SeriesD_all.dx SeriesD.dx];
SeriesD_all.C = [SeriesD_all.C SeriesD.C];
SeriesD_all.dI0 = [SeriesD_all.dI0 SeriesD.dI0];
SeriesD_all.dI1 = [SeriesD_all.dI1 SeriesD.dI1];
SeriesD_all.dI2 = [SeriesD_all.dI2 SeriesD.dI2];
SeriesD_all.dI3 = [SeriesD_all.dI3 SeriesD.dI3];


end