# Changes (tidy-up branch)

## Configuration restructuring (`cfg` -> `config`)

- **New `CreateConfig(volume, verbosity, mode)`** replaces `SetupCfg`. Three master knobs cascade into all downstream flags.
- **Nested sub-structs by concern**: `config.preset`, `config.job`, `config.flags`, `config.problem`, `config.output`, `config.monitor`, `config.style`.
- **Mode knob** (`'basic'`, `'time_order'`, `'space_order'`, `'MC_AF'`) sets workflow-level defaults, replacing manual flag overrides in main scripts.
- `SetupCfg.m` deleted.

## Diagnostics restructuring (`CGD` -> `D`)

- **New `CreateDiagnostics()` factory** returns a guaranteed skeleton with all sub-structs present. No more conditional field existence.
- **New `CreateSeriesDiagnostics(mode)` factory** replaces ad-hoc inline struct construction in main scripts.
- Sub-structs by concern: `D.invariants`, `D.amplification`, `D.posden`, `D.error`, `D.constr_error`, `D.runtime`.

## Exact solution struct (`ES`)

- `LoadExactSolution` now returns a self-contained `ES` struct (type `'exact_solution'`) with soliton parameters, 1D/2D solution handles, and domain info.
- `SetupProblem` unpacks `ES` into `CP` when `config.flags.compare2exact == 1`, keeping `CP` consistent across all branches.

## Type tagging and assertions

- All major structs carry a `.type` field: `'config'`, `'continuous_problem'`, `'spatial_discretization'`, `'solver_state'`, `'diagnostics'`, `'series_diagnostics'`, `'exact_solution'`.
- New `assertStructType(s, expected_type, caller)` utility, called at function entry (not in the hot loop).
- Input validation in `CreateConfig` for master knobs and valid mode strings.

## CP consistency

- `CP.Limits` is always `[a, b]` (2 elements). The exact-solution branch previously returned 4.
- `CP.SpectrumIntensity` is always set (0 for exact-solution and default branches, which were missing it).

## SetupProblem refactor

- Common fields (`p`, `q`, `sigma`, `dx0`, `dt0`, `maxtime`) set once at the top.
- Branches only set what differs: `C`, `L`, `Timescale`, `problemname`, `IC`.
- New local helper `FixedInhomogeneity()` extracts the shared IC used by Fig6 and Fig7.

## Spatial discretization cleanup

- Added comments explaining Kronecker product construction, periodic GammaMatrix wrapping, and 4th-order FD stencil coefficients.
- Fixed function signature (declared unused second output).
- Converted `varargout` to named outputs in the 1D helper.

## Bug fix: `ExecuteSingleRun_lin`

- Was calling `timestep()` (nonlinear) instead of `timestep_lin()`. Fixed.

## Timestep documentation

- Added header comments explaining the implicit midpoint/leapfrog scheme.
- Documented the Hermiticity enforcement step.

## Phi_from_u cleanup

- Replaced `repmat` with implicit broadcasting (`PosDen' - PosDen`).

## Plotting utilities

- `f_of_x_save_fig` now respects `config.output.save_pdfs` (previously always exported PDF).
- All path construction uses `fullfile(config.job.path, ...)` consistently.

## General

- All `disp([...])` replaced with `fprintf(...)` for consistency.
- Updated README with new struct documentation and configuration section.
