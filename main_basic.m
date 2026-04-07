clc; close all; clear all

init;

config = CreateConfig(1, 1, 'basic');

config

CP = SetupProblem(config)

dt = 0.002;
dx = 0.12;
T  = 0.01 * CP.Timescale;

[D, state_new] = ExecuteSingleRun(config, CP, dx, dt, T);
