function ES = LoadExactSolution(varargin)
%% Load an exact soliton solution for validation.
%
%  ES = LoadExactSolution()       % default seed=2
%  ES = LoadExactSolution(seed)   % seed=1 or seed=2
%
%  Returns an ES (exact solution) struct containing the 1D NLS soliton,
%  its periodic wrapping, and the 2D second-moment form for the Alber
%  equation.
%
%  The NLS is normalized as:  i u_t + p Delta u + q |u|^2 u = 0.
%  The 2D Alber solution is:  u_exact2(x,y,t) = u(x,t) * conj(u(y,t)).
%
%  The domain is chosen large enough that the soliton is effectively zero
%  at the boundary, ensuring valid periodic extension.

if nargin == 0
    seed = 2;
else
    seed = varargin{1};
end

%% Type tag
ES.type           = 'exact_solution';
ES.schema_version = 1;

%% Build soliton based on seed
if seed == 1
    % Simple soliton: A=1, v=2, p=1, q=2
    ES.params.p = 1;
    ES.params.q = 2;
    ES.params.A = 1;
    ES.params.v = 2;
    ES.params.k = 1;       % k = 0.5*v/p
    ES.params.omega = 0;   % omega = p*k^2 - q*A^2/2
    ES.params.B = 1;       % B = A*sqrt(0.5*q/p)

    a = -8*pi;
    b =  8*pi;
    L = b - a;

    WrapAround = @(xi) mod(xi - a, L) + a;

    u_exact         = @(x,t) sech(x - 2*t) .* exp(1i*x);
    u_exact_wrapped = @(x,t) sech(WrapAround(x - 2*t)) .* exp(1i*WrapAround(x));

    ES.name      = 'Soliton with A=1, v=2, p=1, q=2';
    ES.Timescale = L / 2;  % time for soliton to do a full lap
    ES.maxtime   = inf;
    ES.dx0       = 9e-2;
    ES.dt0       = 2e-2;

elseif seed == 2
    % General soliton with free parameters
    A = 1.3;   % amplitude
    v = 3.1;   % velocity
    p = 1.7;   % equation coefficient
    q = 1.1;   % equation coefficient (same sign as p)

    k     = 0.5 * v / p;
    omega = p * k^2 - q * A^2 / 2;
    B     = A * sqrt(0.5 * q / p);

    ES.params.p     = p;
    ES.params.q     = q;
    ES.params.A     = A;
    ES.params.v     = v;
    ES.params.k     = k;
    ES.params.omega = omega;
    ES.params.B     = B;

    % Domain: m half-wavelengths of the carrier, enough to contain the soliton
    m = round(4 * k / B);
    a = -m * pi / k;
    b =  m * pi / k;
    L = b - a;

    WrapAround = @(xi) mod(xi - a, L) + a;

    u_exact         = @(x,t) A * sech(B*(x - v*t)) .* exp(1i*(k*x - omega*t));
    u_exact_wrapped = @(x,t) A * sech(B*WrapAround(x - v*t)) .* exp(1i*(k*x - omega*t));

    ES.name      = sprintf('Soliton with A=%g, v=%g, p=%g, q=%g', A, v, p, q);
    ES.Timescale = L / v;  % time for soliton to do a full lap
    ES.maxtime   = inf;
    ES.dx0       = 0.1;    % calibrate with k
    ES.dt0       = 0.01;   % calibrate with omega

else
    error('[LoadExactSolution] Unknown seed %d.', seed);
end

%% Validate periodicity of the wrapped solution
xx = linspace(a, b, 1e4);
wrap_err = max(abs(u_exact(xx, 0) - u_exact_wrapped(xx, 0)));
if wrap_err > 1e-14
    figure;
    plot(xx, real(u_exact(xx, 0))); hold on;
    plot(xx, real(u_exact_wrapped(xx, 0)));
    legend('exact', 'wrapped');
    error('[LoadExactSolution] Domain too small: periodicity error = %.2e.', wrap_err);
end

%% Store solution handles
ES.Limits = [a, b];   % always 2 elements
ES.Gamma  = @(x) 0;   % no background spectrum for exact soliton

% 1D handles
ES.u         = u_exact;
ES.u_wrapped = u_exact_wrapped;

% 2D second-moment handles: u2(x,y,t) = u(x,t) * conj(u(y,t))
ES.u2         = @(x,y,t) u_exact(x,t) .* conj(u_exact(y,t));
ES.u2_wrapped = @(x,y,t) u_exact_wrapped(x,t) .* conj(u_exact_wrapped(y,t));

% Initial condition for the Alber equation
ES.IC = @(x,y) ES.u2_wrapped(x, y, 0);

end
