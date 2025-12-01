# rcn_Alber_MATLAB
Solver for the Alber equation. Full paper at [arXiv:2506.06879]((https://arxiv.org/abs/2506.06879)) 

The paper presents the numerical scheme, explains the exact solution used, defines the constraint error and frames the time order, space order and Monte Carlo series of runs. Please note that the scripts here in their current form do not exactlty match the runs in the paper (but they can be easily modified to do so).

To run, call any of the "main" m-files:
* `main_basic` executes a single run. By default compares to an exact solution; other initial conditions can be selected.
* `main_time_order` executes a series of runs, comparing to an exact solution, to find the experimental order of convergence (EOC) in time (expected to be 2).
* `main_space_order` executes a series of runs, comparing to an exact solution, to find the EOC in space (expected to be 4).
* `main_MC_AF` executes a Monte Carlo (MC) series of runs, investigating the total amplification factor (AF) for randomized initial conditions and intensity of a background Gaussian spectrum.

Most of these main scripts are setup by default with short final times `T`, to enable quick benchmarking. 

Comemnts and diagnostics are printed in the command window and recorded in a log file in outputs. Plots may be saved in outputs (in a different folder for each job) according to the options specifid in `cfg` (see below).

Throughout the code, the variables are organized in a number of structs:
* `cfg` (configuration) has all the flags of what kinds of diagnostics to compute, print, plot and save; whether figures are visible or not etc. 
* `CP` (Continuous Problem) has the initial condition (as a function handle), parameters of the equation, homogeneous background (as a function handle), and computational domain. In other words, all the information that would be required to fully specify the continuous problem (on a finite computational domain) before any discretization takes place. It also supports recommended baseline values for dx, dt to be used with the initial condition in question.
* `SD` (Spatial Discretization) holds the matrices and meshes used in the simualtion. It is created based on an intended dx, but the exact dx may be different (as the length of the computational domain is preset in CP).
* `state` is a struct containing the current state of the solver. Typically there are two states, `state_new` and `state_old` (out of which `state_new` is computed during each timestep). `state_new` contains discrete U^n, discrete Phi^{n-1/2}, discrete times t^n, t^{n-1/2}.

Please note that links on the command prompt are deactivated for logging purposes. You can turn them back on with the command `feature('HotLinks', 'n');`.

The code was prepared and runs on R2023b. 
