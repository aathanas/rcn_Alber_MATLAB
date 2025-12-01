function CP = SetupProblem(cfg)
% create a CP (=continuous problem) struct with parameters for 
% the continuous problem
% \[
% 		i \partial_t u + p (\Delta_x - \Delta_y) u + q ( u(x,x,t)-u(y,y,t) ) ( \Gamma(x-y)  + u(x,y,t) )=0,  
%            (x,y) \in [-L/2,L/2]^2,
%            u(x,y,0) = u0(x,y)
% \]
% equipped with periodic boundary conditions. See arXiv:2506.06879 for more
% details.



if cfg.compare2exact

    CP = LoadExactSolution;

elseif cfg.MC_AF_run

    CP.p = 1;
    CP.q = 1;

    sigma=0.36;
    C= 1.5 + randn(1)*0.2;
    CP.SpectrumIntensity = C;


    CP.Gamma = @(x) C^2  * exp(-pi*sigma^2*x.^2); % must be an autocorrelation,
    % i.e., the Fourier transform of a non-negative function

    L=22;
    CP.Limits = [-L/2 L/2]; % limits of the computational domain in the
    % format [xmin xmax]. The ymin=xmin and xmax=xmin by the symmetry of
    % the problem.

    CP.problemname = 'inhomogeneity over Gaussian background'; % a string to describe this solution

    CP.dx0 = 1e-2; % recommended baseline space discretization (order of magnitude)
    CP.dt0 = 1e-3; % recommended baseline time discretization (order of magnitude)
    % both these values are taken to characterise the continuous problem,
    % i.e. what kind of meshes does this problem require in principle





    CP.Timescale = 10; % an O(1) meaningful timescale for this problem

    CP.maxtime = inf; % a timescale beyond which it makes no sense to go
    % e.g. exact solution breaks down etc


    CP.IC = RandomizeInhomogeneity(L); % a random inhomogeneity,
    % that is numerically zero at the end of the computational domain, and that
    % has O(1) scales and L^p norm. It is Hermitian by default, to be consistent with
    % the physical context.

else % you can put your favorite continuous problem here

    CP.p = 1;
    CP.q = 1;

    sigma=0.36;
    C= 1.5;



    CP.Gamma = @(x) C^2  * exp(-pi*sigma^2*x.^2); % must be an autocorrelation,
    % i.e., the Fourier transform of a non-negative function

    L=22;
    CP.Limits = [-L/2 L/2]; % limits of the computational domain in the
    % format [xmin xmax]. The ymin=xmin and xmax=xmin by the symmetry of
    % the problem.

    CP.problemname = 'inhomogeneity over Gaussian background'; % a string to describe this solution

    CP.dx0 = 1e-2; % recommended baseline space discretization (order of magnitude)
    CP.dt0 = 1e-3; % recommended baseline time discretization (order of magnitude)
    % both these values are taken to characterise the continuous problem,
    % i.e. what kind of meshes does this problem require in principle





    CP.Timescale = 10; % an O(1) meaningful timescale for this problem

    CP.maxtime = inf; % a timescale beyond which it makes no sense to go
    % e.g. exact solution breaks down etc


    v0 = @(x,y) exp(-1.5 *x.^2 -1.6*y.^2);
    CP.IC = @(x,y) 0.5 * ( v0(x,y) + conj( v0(y,x) ) );


end








end