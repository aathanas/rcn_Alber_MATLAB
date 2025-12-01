function u0 = RandomizeInhomogeneity(L)


s = 17 * log(10) / (L/2)^2;

n=5;
z=( randn(1,n) + 1i * randn(1,n) )/sqrt(2);


v0 = @(x,y) exp(-s*(x.^2+y.^2)) .* ( z(1) *exp(6*pi*1i *x /L) + z(2)*exp(7*pi*1i *y /L) + 0.5* z(3) *exp(6.5*pi*1i *(y+x)/L)  + 0.2*z(4)*exp(11*pi*1i*x/L - 13*pi*1i*y/L) );

u0 = @(x,y) 0.02 * 0.5 * ( v0(x,y) + conj( v0(y,x) ) );
end