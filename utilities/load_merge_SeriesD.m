clc; close all; clear all


load SeriesD_1.mat


SeriesD_all = SeriesD;

for jj=2:16

    eval(['load SeriesD_' num2str(jj) '.mat'])

    SeriesD_all = Merge_SeriesD(SeriesD,SeriesD_all);

    pause(1)

end