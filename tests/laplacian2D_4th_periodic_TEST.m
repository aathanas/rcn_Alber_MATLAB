function [dx,dy,X,Y,D] = laplacian2D_4th_periodic_TEST(Nx,Ny,Lx,Ly)

% Grid spacing
hx = Lx / Nx;
hy = Ly / Ny;

% Periodic grid (endpoint excluded!)
x = (0:Nx-1)' * hx - Lx/2;
y = (0:Ny-1)' * hy - Ly/2;

dx = x(2)-x(1);
dy=dx;

[X,Y] = meshgrid(x,y);

% --- 1D 4th-order periodic second derivative in x ---

ex = ones(Nx,1);

Dxx = spdiags([-1*ex 16*ex -30*ex 16*ex -1*ex], ...
              [-2 -1 0 1 2], Nx, Nx);

% periodic wrap entries
Dxx(1,end)   = 16;
Dxx(1,end-1) = -1;
Dxx(2,end)   = -1;

Dxx(end,1) = 16;
Dxx(end-1,1) = -1;
Dxx(end,2) = -1;

Dxx = Dxx / (12*hx^2);

% --- 1D 4th-order periodic second derivative in y ---

ey = ones(Ny,1);

Dyy = spdiags([-1*ey 16*ey -30*ey 16*ey -1*ey], ...
              [-2 -1 0 1 2], Ny, Ny);

% periodic wrap entries
Dyy(1,end)   = 16;
Dyy(1,end-1) = -1;
Dyy(2,end)   = -1;

Dyy(end,1) = 16;
Dyy(end-1,1) = -1;
Dyy(end,2) = -1;

Dyy = Dyy / (12*hy^2);

% --- 2D Laplacian via Kronecker products ---

Ix = speye(Nx);
Iy = speye(Ny);

D = kron(Iy, Dxx) + kron(Dyy, Ix);

end