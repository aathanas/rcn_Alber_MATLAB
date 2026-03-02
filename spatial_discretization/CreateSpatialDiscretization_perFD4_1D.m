function [x,eyeN,Delta,Nabla,varargout]=CreateSpatialDiscretization_perFD4_1D(a,b,N)
% Generate the spatial grid x, Laplacian matrix D, and identity matrix
% eyeN for N points in [a,b] with periodic boundary conditions. 
% D is sparse.

    
x=linspace(a,b,N+1)';
x(end)=[];

dx=x(2)-x(1);

e = ones(N,1);
eyeN=spdiags(e, 0, N, N);


Delta = spdiags([-e/12 4*e/3 -5*e/2 4*e/3 -e/12], -2:2, N, N);
Delta(1,N) = 4/3; Delta(1,N-1)=-1/12; % periodic BCs
Delta(2,N)=-1/12; % periodic BCs
Delta(N,1)=4/3; Delta(N,2)=-1/12; % periodic BCs
Delta(N-1,1)=-1/12; % periodic BCs

Delta=Delta/(dx^2);

Nabla=  (-circshift(speye(N), -2) ...   % -f_{i+2}
     +8*circshift(speye(N), -1) ... % +8 f_{i+1}
     -8*circshift(speye(N),  1) ... % -8 f_{i-1}
     +  circshift(speye(N),  2)) ...% + f_{i-2}
     / (12*dx);




varargout{1}=x;
varargout{2}=eyeN;
varargout{3}=Delta;
varargout{4}=Nabla;

end