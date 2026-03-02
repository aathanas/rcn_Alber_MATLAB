function u0 = RandomizeInhomogeneity(L,randomflag)
arguments
    L double = 24
    randomflag logical = 0
end




s = 17 * log(10) / (L/2)^2;



if randomflag
    n=5;
    z = ( randn(1,n) + 1i * randn(1,n) )/sqrt(2);
else
    z = [0.3 + 0.8*1i; -0.2; 0.1*1i];
end


 %v0 = @(x,y) exp(-s*(x.^2+y.^2)) .* ( z(1) *exp(6.5*pi*1i *x /L) + z(2)*exp(9*pi*1i *y /L) + 0.5* z(3) *exp(5*pi*1i *(y+x)/L)  + 0.2*z(4)*exp(12*pi*1i*x/L - 14.12*pi*1i*y/L) ) .* exp(-(x.^4) / (8*L/11)^4 ) .* exp(-(y.^4) / (8*L/11)^4 ) ;
%v0 = @(x,y)   z(1) *exp(6*pi*1i *x /L) + z(2)*exp(8*pi*1i *y /L) + 0.5* z(3) *exp(6*pi*1i *(y+x)/L)  + 0.2*z(4)*exp(12*pi*1i*x/L - 14*pi*1i*y/L)  ;


 v0 = @(x,y) 0.05 .* exp(-0.06 .* x.^2 - 0.07 .* y.^2) .* ...
    (1 + z(1) .* cos(0.3 .* x) .* cos(0.2 .* y) ...
       + z(2) .* x + z(3) .* y);


u0 = @(x,y)  0.5 * ( v0(x,y) + conj( v0(y,x) ) ) ;
end