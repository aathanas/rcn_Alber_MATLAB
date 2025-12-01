function CP=LoadExactSolution(varargin)
% create a soliton solution for focusing NLS with given parameters, and
% then take the second moment to return as an exact solution for Alber
% NLS normalized as i u_t + p Delta u + q |u|^2 u =0. This is then
% periodized over an interval of length L, which is checked to be larger
% than the effective support of the soliton.


if nargin==0
    seed=2;
else
    seed=varargin{1};
end


if seed == 1
    p=1; % rigid for this example
    q=2; % rigid for this example

    a=-8*pi;
    b=8*pi;
    L=b-a;

    WrapAround=@(xi) mod(xi-a,L)+a;
    
    u_exact= @(x,t) sech(x-2*t) .* exp(1i*x);

    %u_exact_wrapped= @(x,t) sech(mod(x-2*t-a,L)+a) .* exp(1i*(mod(x-a,L)+a));
    u_exact_wrapped= @(x,t) sech(WrapAround(x-2*t)) .* exp(1i*(WrapAround(x)));

    maxtime= inf;
    Timescale= L/2; % time it takes a soliton to do a lap
    solutionname='Soliton with A=1, v=2, p=1, q= 2';

    Dt=2e-2;
    Dx=9e-2;

elseif seed == 2

    A=1.3; % soliton amplitude; any real number
    v=3.1; % soliton velocity; any real number 

    p=1.7; % equation coefficient; any real number
    q=1.1; % equation coefficient; any real number (same sign as p)

    k=0.5*v/p;
    omega=p*k^2-q*A^2/2;
    B=A*sqrt(0.5*q/p);

    m=round(4 *k/ B ); 
    a=-m*pi/k;
    b=m*pi/k;



    L=b-a;

    WrapAround=@(xi) mod(xi-a,L)+a;
    
    u_exact= @(x,t) A* sech(B*(x-v*t)) .* exp(1i*( k*x-omega*t  ));

    u_exact_wrapped= @(x,t) A* sech(B*WrapAround(x-v*t)) .* exp(1i*( k*x-omega*t  ));  % unfinished!!

    
    Timescale= L/v; % time it takes a soliton to do a lap
    maxtime= inf;
    solutionname=['Soliton with A=' num2str(A) ', v=' num2str(v) ', p=' num2str(p) ', q=' num2str(q)];
    Dt=0.01; % in general, need to be calibrated with omega
    Dx=0.1; % in general, need to be calibrated with k


end





xx=linspace(a,b,10^4);
if max(abs( u_exact(xx,0)-u_exact_wrapped(xx,0) )) > 1e-14
    figure
    plot(xx,real(u_exact(xx,0)))
    hold on
    plot(xx,real(u_exact_wrapped(xx,0)));
    legend 

    max(abs( u_exact(xx,0)-u_exact_wrapped(xx,0) ))

    error('not large enough computational domain')
end




u_exact2= @(x,y,t) u_exact(x,t) .* conj( u_exact(y,t) );
u_exact_wrapped2= @(x,y,t) u_exact_wrapped(x,t) .* conj( u_exact_wrapped(y,t) );
% the wrapping ensures correct periodic extension once the soliton has left
% the primary computational domain




CP.p = p;
CP.q = q;
CP.Gamma = @(x) 0;
CP.Limits = [a b a b]; % limits of the computational domain in the 
% format [xmin xmax ymin ymax]
CP.problemname = solutionname; % a string to describe this solution
CP.dx0 = Dx; % recommended space discretization (order of magnitude)
CP.dt0 = Dt; % recommended time discretization (order of magnitude)
CP.Timescale = Timescale; % an O(1) timescale for this problem; in 
% this case, the time it takes to do a full lap on the computational domain
CP.maxtime = maxtime; 
CP.ExactSolution = u_exact_wrapped2;
CP.IC = @(x,y) u_exact_wrapped2(x,y,0);

end


