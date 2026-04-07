function [x, eyeN, Delta, Nabla] = CreateSpatialDiscretization_perFD4_1D(a, b, N)
%% 1D periodic finite difference operators (4th order).
%
%  [x, eyeN, Delta, Nabla] = CreateSpatialDiscretization_perFD4_1D(a, b, N)
%
%  Generates the uniform grid, identity, Laplacian, and gradient matrices
%  for N points on [a, b) with periodic boundary conditions.
%
%  Inputs:
%    a, b  — domain endpoints.  The grid covers [a, b) (right endpoint excluded
%            by periodicity).
%    N     — number of grid points.
%
%  Outputs:
%    x     — N x 1 column vector of grid points.
%    eyeN  — N x N sparse identity matrix.
%    Delta — N x N sparse 4th-order periodic Laplacian (d^2/dx^2).
%    Nabla — N x N sparse 4th-order periodic gradient   (d/dx).
%
%  Stencils (standard 4th-order central differences):
%    Delta: [-1/12, 4/3, -5/2, 4/3, -1/12] / dx^2
%    Nabla: [1/12, -2/3, 0, 2/3, -1/12]    / dx

%% Grid: N points on [a, b), excluding right endpoint for periodicity
x  = linspace(a, b, N+1)';
x(end) = [];
dx = x(2) - x(1);

%% Identity
eyeN = speye(N);

%% Laplacian — 4th-order central difference with periodic BCs
%  Interior stencil: [-1/12, 4/3, -5/2, 4/3, -1/12] / dx^2
%  Rows 1, 2, N-1, N wrap around to enforce periodicity.
e = ones(N, 1);
Delta = spdiags([-e/12, 4*e/3, -5*e/2, 4*e/3, -e/12], -2:2, N, N);
Delta(1, N)   =  4/3;   Delta(1, N-1) = -1/12;   % row 1 wraps
Delta(2, N)   = -1/12;                            % row 2 wraps
Delta(N, 1)   =  4/3;   Delta(N, 2)   = -1/12;   % row N wraps
Delta(N-1, 1) = -1/12;                            % row N-1 wraps
Delta = Delta / dx^2;

%% Gradient — 4th-order central difference with periodic BCs
%  Interior stencil: [-f_{i+2} + 8*f_{i+1} - 8*f_{i-1} + f_{i-2}] / (12*dx)
%  circshift on speye handles periodicity automatically.
I = speye(N);
Nabla = (-circshift(I, -2) + 8*circshift(I, -1) ...
         -8*circshift(I, 1) + circshift(I, 2)) / (12*dx);

end
