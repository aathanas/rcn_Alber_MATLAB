function D = CreateDiagnostics()
%% Create the diagnostics struct with a guaranteed skeleton.
%
%  D = CreateDiagnostics()
%
%  Returns a D struct with all sub-structs present and initialized
%  to empty/NaN defaults.  This eliminates conditional field-existence
%  checks downstream — every field is always present.
%
%  D is a per-run struct.  It tracks time histories within a single run:
%    D.amplification.TAF is a growing vector of TAF at each recorded time.
%  For cross-run aggregation, see CreateSeriesDiagnostics.

%% Type tag
D.type           = 'diagnostics';
D.schema_version = 1;

%% Time vector (grows as diagnostics are recorded)
D.tvec = [];

%% Runtime
D.runtime.comp_time = NaN;

%% Invariants (I_0 .. I_3)
D.invariants.initial = NaN(4, 1);   % at t = 0
D.invariants.final   = NaN(4, 1);   % at t = T
D.invariants.dI      = NaN(4, 1);   % relative changes
D.invariants.history = [];           % 4 x M matrix over time

%% Amplification factors
D.amplification.rho0 = NaN;         % initial amplitude (denominator for TAF)
D.amplification.TAF  = [];           % total amplification factor over time
D.amplification.IAF  = [];           % inhomogeneity amplification factor over time

%% Position density
D.posden.snapshots = [];             % N x M matrix of diag(U) snapshots
D.posden.L2        = [];             % L2 norm over time
D.posden.Linf      = [];             % Linf norm over time

%% Constraint error
D.constr_error = [];

%% Error vs exact solution
D.error.L2_U    = [];
D.error.Linf_U  = [];
D.error.L2_Phi  = [];
D.error.Linf_Phi = [];

end
