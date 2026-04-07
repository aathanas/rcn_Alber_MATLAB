function SD = CreateSpatialDiscretization(CP, dx)
%% Build the 2D spatial discretization struct from the continuous problem.
%
%  SD = CreateSpatialDiscretization(CP, dx)
%
%  Constructs the uniform grid, 2D differential operators, and the
%  evaluated GammaMatrix on [-L/2, L/2]^2.  The 2D operators are built
%  from 1D 4th-order periodic finite differences via Kronecker products.
%
%  The actual dx may differ slightly from the requested value, because
%  the domain length must be an exact multiple of dx.
%
%  Inputs:
%    CP  — continuous problem struct (needs .Limits and .Gamma).
%    dx  — target grid spacing.
%
%  Outputs:
%    SD  — spatial discretization struct with fields documented below.

assertStructType(CP, 'continuous_problem', 'CreateSpatialDiscretization');
assert(numel(CP.Limits) == 2, ...
    '[CreateSpatialDiscretization] CP.Limits must have exactly 2 elements.');

a = CP.Limits(1);
b = CP.Limits(2);

%% Determine grid size (round to fit integer number of cells in domain)
N = round((b - a) / dx);

%% 1D operators (4th-order periodic FD)
[x, ~, D1, Nabla1] = CreateSpatialDiscretization_perFD4_1D(a, b, N);

%% By symmetry of the Alber equation, y uses the same grid as x
y = x;
[X, Y] = meshgrid(x, y);

%% 2D operators via Kronecker products
%  Dhyp = d^2/dx^2 - d^2/dy^2  (hyperbolic Laplacian on the (x,y) domain)
%  Implemented as:  kron(D1, I) operates on x, kron(I, D1) operates on y.
eyeN_1D = speye(N);
Dhyp = kron(D1, eyeN_1D) - kron(eyeN_1D, D1);

%  Nabla_x_minus_y = d/dx - d/dy  (used in invariant computation)
Nabla_x_minus_y = kron(Nabla1, eyeN_1D) - kron(eyeN_1D, Nabla1);

%  2D identity (N^2 x N^2, used in the implicit time-stepping matrix)
eyeN_2D = speye(N^2);

%% Pack the SD struct
SD.type            = 'spatial_discretization';
SD.schema_version  = 1;
SD.dx              = x(2) - x(1);  % actual dx (may differ from requested)
SD.dy              = SD.dx;         % identical by symmetry
SD.N               = N;
SD.x               = x;
SD.y               = y;
SD.X               = X;
SD.Y               = Y;
SD.eyeN            = eyeN_2D;
SD.Dhyp            = Dhyp;
SD.Nabla_x_minus_y = Nabla_x_minus_y;

%% Evaluate Gamma(x-y) on the mesh with periodic extension
%  mod(X-Y - a, b-a) + a maps the difference X-Y into [a, b), implementing
%  the periodic extension of Gamma over the computational domain.
SD.GammaMatrix = CP.Gamma(mod(SD.X - SD.Y - a, b - a) + a);

fprintf('[CreateSpatialDiscretization] dx = %g on [%g, %g]^2.\n', SD.dx, a, b);
fprintf('[CreateSpatialDiscretization] %dx%d sparse matrices inverted each timestep.\n', ...
    N^2, N^2);

end
