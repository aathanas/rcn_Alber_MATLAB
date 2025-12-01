function AF = AmplificationFactor(CP,SD,CGD,state)



AF = max(max(abs( state.U + CP.Gamma(SD.X - SD.Y) ))) / CGD.rho0;



end