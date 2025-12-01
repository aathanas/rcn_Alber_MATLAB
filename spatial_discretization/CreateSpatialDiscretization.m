function [SD,this_dx]=CreateSpatialDiscretization(CP,dx)
% returns the SD (spatial discretization) struct
% takes as input a running spatial mesh size dx, and returns a possibly
% slightly adjusted value of it

a = CP.Limits(1);
b = CP.Limits(2);

N=round ( (b-a)/dx );



[x,eyeN,D,Nabla]=CreateSpatialDiscretization_perFD4_1D(a,b,N);
% This creates the 1D versions of the basic matrices that we will need.
% Currently we only use 4th order FD wiht periodic BC in this solver.
% Other ways to discretize space (e.g. 2nd order FD, spectral)
% or other boundary conditions could be included here. 

y=x;
% by symmetry of the problem, the mesh in y has to be the same as in x


[X,Y]=meshgrid(x,y);
% meshgrid matrices for x, y

Dhyp = kron(D, eyeN) - kron(eyeN, D);
% matrix for the hyperbolic Laplacian generated from the matrix for the 1D
% Laplacian using the Krinecker product

Nabla_x_minus_y = kron(Nabla, eyeN) - kron(eyeN, Nabla);
% this matrix will be used when evaluating the invariants

eyeN=speye(N^2);
% the 2D identity matrix is used



% packing the SD struct
SD.dx=x(2)-x(1); % exact dx may not be exactly the one intended due having to fit an integer
% number of dx's in the computational domain
SD.N = length(x);
SD.x=x;
SD.y=y;
SD.X=X;
SD.Y=Y;
SD.eyeN=eyeN;
SD.Dhyp=Dhyp;
SD.Nabla_x_minus_y=Nabla_x_minus_y;





disp(['[CreateSpatialDiscretization] Using dx = ' num2str(SD.dx) ' on [' num2str(a) ',' num2str(b) ']^2.'])
disp(['[CreateSpatialDiscretization] ' num2str(SD.N^2) 'x' num2str(SD.N^2) ' sparse matrices will be inverted in every timestep.'])
end