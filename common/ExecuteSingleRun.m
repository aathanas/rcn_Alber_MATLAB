function [CGD,state_new] = ExecuteSingleRun(cfg,CP,dx,dt,T)


SD = CreateSpatialDiscretization(CP,dx);
% SD --> Spatial Discretization
% contains all the objects that are needed to create the fully discrete
% problem, including meshes, derivative matrices etc
% These are all sparse matrices.
% this_dx value may be slightly adjusted to fit exact multiples of dx in L


state_old = Initialization(cfg,CP,SD,dt,T);
% state --> state of the solver that is updated every timestep (U, Phi, t)
% create the discrete initial state, according to initialization type
% can also give an estimate of runtime (that's why it needs T)


%% Single run is exectuted in this section 



CGD = PreProcessing(cfg,CP,SD,state_old);
% CGD --> Coarse Grained Diagnostics
% Returns discrete version of the initial state,
% includes the initialization of Phi^{-1/2} according to cfg.init_type,
% produces initial plots and initial diagnostics as required


%% main time loop

tcount = 0;
tic;
while state_old.t < T

    tcount = tcount + 1;

    state_new = timestep(CP,dt,state_old,SD);


    if ( mod(tcount,cfg.keep_track_frequency) == 0 ) && cfg.keep_track_frequency > 0
        CGD = UpdateDiagnostics(cfg,CP,SD,state_old,state_new,CGD);
    end

    state_old = state_new;

end
main_comp_time = toc;
CGD.run_comp_time = main_comp_time;

disp(['[main] main time loop complete after ' num2str(main_comp_time/60) ' minutes']);


CGD = PostProcessing(cfg,CP,SD,state_old,CGD);




end