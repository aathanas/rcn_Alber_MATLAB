function state = Initialization(cfg,CP,SD,dt,T)
% Create the initial state of the solver


%% % naive initialization
uOld = CP.IC(SD.X,SD.Y);
PhiOld = Phi_from_u(uOld);


state.U = uOld;
state.Phi=PhiOld;
state.t=0;



%% advanced initializtion

if strcmp(cfg.init_type,'advanced')
    disp('[PreProcessing] Performing advanced initialization step... ')
    tic;
    staux = timestep(CP,-dt/2,state,SD);
    step_time = toc;

    disp(['[PreProcessing] Roughly ' num2str(step_time) 's per timestep.'])
    disp(['[PreProcessing] Expected roughly ' num2str(ceil(T*step_time / (dt * 60))) ' minutes to finish this run.'])
    disp(datestr(now, 'dd-mmm-yyyy_HH-MM-SS'))

    PhiOld = Phi_from_u(staux.U);
end

state.U = uOld;
state.Phi = PhiOld;
state.t=0;
state.t_minus_half = -dt/2;

end