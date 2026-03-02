clc; close all; clear all;


L=12;
dx = 0.02;
N=round(L/dx);



old =1
if old

x = linspace(-L/2,L/2,N);

dx = x(2)-x(1);
dy=dx;

[X,Y] = meshgrid(x,x);

[x,eyeN,D,Nabla]=CreateSpatialDiscretization_perFD4_1D(-L/2,L/2,N);
D2 = kron(D, eyeN) + kron(eyeN, D);

else

[dx,dy,X,Y,D2] = laplacian2D_4th_periodic_TEST(N,N,L,L);

end


envelope = exp(-2*X.^2 - 0.3*Y.^2);
f = exp(2*pi*1i*X/L + 4*pi*1i*Y/L) .* envelope ;


Df = unvec( D2 * f(:) , N);

figure
mesh(real(f))


sum( sum( Df )) *dx*dy

min( min( abs( envelope  )))
