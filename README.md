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

By default, figures are not displayed interactively — they are saved directly to the `outputs/` subfolder as PDF and `.fig` files. This makes the code safe to run on HPC clusters without a display. To enable interactive figures, set `config.flags.interactive = 1` after calling `CreateConfig`.

To modify initial conditions, edit `SetupProblem` in the `problem_specific/` folder.

Each run creates a timestamped subfolder under `outputs/`. Plots are saved there according to the flags in `config`. Comments and diagnostics are printed to the command window and recorded in a log file in the timestamped subfolder.

## Configuration

Configuration is created via `CreateConfig(volume, verbosity, mode)` with three master knobs:

| Knob | Values | Controls |
|------|--------|----------|
| `volume` | 0/1/2 | File saving (0=none, 1=per-flag, 2=everything) |
| `verbosity` | 0/1/2 | Plots and console output (0=silent, 1=standard, 2=all) |
| `mode` | `'basic'`, `'time_order'`, `'space_order'`, `'MC_AF'` | Workflow type |

The `mode` knob cascades into appropriate defaults for series runs, exact-solution comparison, and diagnostics tracking. Individual flags can be overridden after creation.

## Code structure
Throughout the code, variables are organized in type-tagged structs (each carries a `.type` field checked at function entry via `assertStructType`):

* `config` (configuration) — master knobs, flags, output/monitor settings, job identity, and style. Created by `CreateConfig`. Organized into sub-structs: `.preset`, `.job`, `.flags`, `.problem`, `.output`, `.monitor`, `.style`.
* `CP` (Continuous Problem) — initial condition, equation parameters, background spectrum, and computational domain, all specified before any discretization. Also carries recommended baseline values for `dx` and `dt`.
* `SD` (Spatial Discretization) — matrices and meshes for the simulation, built from a target `dx` (exact value may differ as the domain length is fixed in `CP`). Includes 4th-order periodic finite difference operators constructed via Kronecker products.
* `state` — current solver state. Two instances are kept at each timestep (`state_old`, `state_new`), containing discrete `U^n`, `Phi^{n-1/2}`, and the corresponding times.
* `D` (Diagnostics) — per-run diagnostics with sub-structs: `.invariants`, `.amplification`, `.posden`, `.error`, `.constr_error`, `.runtime`. Created by `CreateDiagnostics` with a guaranteed skeleton.
* `SeriesD` (Series Diagnostics) — cross-run aggregation for convergence studies or Monte Carlo runs. Created by `CreateSeriesDiagnostics(mode)`.
* `ES` (Exact Solution) — soliton solution metadata returned by `LoadExactSolution`, unpacked into `CP` for validation runs.

Note: hyperlinks in the command window are disabled for cleaner log files. Re-enable with `feature('HotLinks', 1)`.

## Reproducing paper results
The `reproduce/` folder contains scripts that reproduce specific figures and tables from the paper [arXiv:2506.06879]. They can be run directly from that folder — each script changes directory to the project root automatically before initializing.

* `Rep_Figures_1to4` — Figures 1–4 (validation against exact solution).
* `Rep_Figure_6` — Figure 6 (stable Gaussian background, `C=0.9`).
* `Rep_Figure_7` — Figure 7 (strongly unstable Gaussian background, `C=1.9`).
* `Rep_Figure_8` — Figure 8 (nonlinear vs linearized solver, `C=1.9`).
* `Rep_Table_1` — Table 1 (time EOC, advanced initialization).
* `Rep_Table_2` — Table 2 (space EOC, advanced initialization).
* `Rep_Table_3` — Table 3 (time EOC, naive initialization).
* `Rep_Table_4` — Table 4 (space EOC, naive initialization).
* `RepAll` — runs all reproduction scripts sequentially.

## Compatibility
Tested on MATLAB R2023b and R2025b.
