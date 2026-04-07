function CP = SetupProblem(config)
%% Create a CP (continuous problem) struct.
%
%  CP = SetupProblem(config)
%
%  Builds the continuous problem for the Alber equation:
%    i u_t + p (Delta_x - Delta_y) u + q (u(x,x)-u(y,y)) (Gamma(x-y) + u) = 0
%  on [-L/2, L/2]^2 with periodic BCs.  See arXiv:2506.06879 for details.
%
%  The problem is selected by config.flags.compare2exact and
%  config.problem.reproduce.

assertStructType(config, 'config', 'SetupProblem');

%% Exact-solution branch — unpack ES into CP
if config.flags.compare2exact
    ES = LoadExactSolution();

    CP.type              = 'continuous_problem';
    CP.schema_version    = 1;
    CP.p                 = ES.params.p;
    CP.q                 = ES.params.q;
    CP.Gamma             = ES.Gamma;
    CP.SpectrumIntensity = 0;   % no background spectrum for soliton validation
    CP.Limits            = ES.Limits;
    CP.problemname       = ES.name;
    CP.dx0               = ES.dx0;
    CP.dt0               = ES.dt0;
    CP.Timescale         = ES.Timescale;
    CP.maxtime           = ES.maxtime;
    CP.IC                = ES.IC;
    CP.ExactSolution     = ES.u2_wrapped;
    CP.ES                = ES;   % keep full ES struct for downstream validation
    return
end

%% Common defaults for all Gaussian-background problems
CP.type              = 'continuous_problem';
CP.schema_version    = 1;
CP.p                 = 1;
CP.q                 = 1;
sigma                = 0.36;
CP.dx0               = 1e-2;   % recommended baseline spatial resolution
CP.dt0               = 1e-3;   % recommended baseline temporal resolution
CP.maxtime           = inf;

%% Per-problem overrides — only set what differs
reproduce = config.problem.reproduce;

if strcmp(reproduce, 'MC_AF')
    C = 0.9 + rand(1);
    L = config.problem.L;
    CP.Timescale   = 10;
    CP.problemname = 'inhomogeneity over Gaussian background';
    CP.IC          = RandomizeInhomogeneity(L, config.flags.randomflag);

elseif strcmp(reproduce, 'Fig7')
    C = 1.9;
    L = 50;
    CP.Timescale   = 20;
    CP.problemname = 'inhomogeneity over strongly unstable Gaussian background';
    CP.IC          = FixedInhomogeneity();

elseif strcmp(reproduce, 'Fig6')
    C = 0.9;
    L = 50;
    CP.Timescale   = 20;
    CP.problemname = 'inhomogeneity over stable Gaussian background';
    CP.IC          = FixedInhomogeneity();

else
    % Default problem (main_basic): weakly unstable
    C = 1.29;
    L = 12;
    CP.Timescale   = 20;
    CP.problemname = 'inhomogeneity over weakly unstable Gaussian background';
    v0    = @(x,y) exp(-0.1*x.^2 - 0.2*y.^2) .* (1 + x.^2 + cos(y));
    CP.IC = @(x,y) 0.095 * (v0(x,y) + conj(v0(y,x)));
end

%% Common finalization
CP.SpectrumIntensity = C;
CP.Gamma  = @(x) C^2 * exp(-pi * sigma^2 * x.^2);
CP.Limits = [-L/2, L/2];

end


%% ===== Local helper =====

function u0 = FixedInhomogeneity()
%% Fixed inhomogeneity IC shared by Fig6 and Fig7 presets.
%  Uses the same z coefficients and v0 formula as the paper.

z = [0.3 + 0.8i; -0.2; 0.1i];

v0 = @(x,y) 0.05 .* exp(-0.06 .* x.^2 - 0.07 .* y.^2) .* ...
    (1 + z(1) .* cos(0.3 .* x) .* cos(0.2 .* y) ...
       + z(2) .* x + z(3) .* y);

u0 = @(x,y) 0.5 * (v0(x,y) + conj(v0(y,x)));
end
