# rcn_Alber_MATLAB
Solver for the Alber equation, implemented in MATLAB. Full paper at [arXiv:2506.06879](https://arxiv.org/abs/2506.06879)

## Setup
Clone or download the repository and keep the folder structure intact. Set MATLAB's working directory to the project root before running any script.

## Running the solver
Call any of the `main_*` scripts from the project root. They run with default parameters and short final times `T` to enable quick benchmarking.

* `main_basic` — a single run, set up with a default problem; other initial conditions and parameters can be selected in `problem_specific/SetupProblem`.
* `main_time_order` — a series of runs comparing to an exact solution to find the experimental order of convergence (EOC) in time (expected: 2).
* `main_space_order` — a series of runs comparing to an exact solution to find the experimental order of convergence (EOC) in space (expected: 4).
* `main_MC_AF` — a Monte Carlo series of runs investigating the total amplification factor (TAF) and inhomogeneity amplification factor (IAF) for randomized initial conditions over a Gaussian background spectrum.

By default, figures are not displayed interactively — they are saved directly to the `outputs/` subfolder as PDF and `.fig` files. This makes the code safe to run on HPC clusters without a display. To enable interactive figures, set `cfg.interactive = 1` in `common/SetupCfg`.

To modify initial conditions, edit `SetupProblem` in the `problem_specific/` folder.

Each run creates a timestamped subfolder under `outputs/`. Plots are saved there according to the flags in `cfg`. Comments and diagnostics are printed to the command window and recorded in a log file in the timestamped subfolder.

## Code structure
Throughout the code, variables are organized in structs:
* `cfg` (configuration) — flags controlling what diagnostics to compute, print, plot and save.
* `CP` (Continuous Problem) — initial condition, equation parameters, background spectrum, and computational domain, all specified before any discretization. Also carries recommended baseline values for `dx` and `dt`.
* `SD` (Spatial Discretization) — matrices and meshes for the simulation, built from a target `dx` (exact value may differ as the domain length is fixed in `CP`).
* `state` — current solver state. Two instances are kept at each timestep (`state_old`, `state_new`), containing discrete `U^n`, `Phi^{n-1/2}`, and the corresponding times.

Note: hyperlinks in the command window are disabled for cleaner log files. Re-enable with `feature('HotLinks', 1)`.

## Reproducing paper results
The `reproduce/` folder contains scripts that reproduce specific figures and tables from the paper [arXiv:2506.06879]. They can be run directly from that folder — each script changes directory to the project root automatically before initializing.

* `Rep_Figures_1to4` — Figures 1–4 (validation against exact solution).
* `Rep_Figure_6` — Figure 6 (stable Gaussian background, `C=0.9`).
* `Rep_Figure_7` — Figure 7 (strongly unstable Gaussian background, `C=1.9`).
* `Rep_Table_1` — Table 1 (time EOC, advanced initialization).
* `Rep_Table_2` — Table 2 (space EOC, advanced initialization).
* `Rep_Table_3` — Table 3 (time EOC, naive initialization).
* `Rep_Table_4` — Table 4 (space EOC, naive initialization).

## Compatibility
Tested on MATLAB R2023b and R2025b.
