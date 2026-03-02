function [TAF,IAF] = AmplificationFactor(CP,SD,CGD,state)



TAF = max(max(abs( state.U + SD.GammaMatrix ))) / CGD.rho0;


IAF = max(max( abs( state.U   ) )) / max( max( abs( CP.IC(SD.X,SD.Y) ) ));



end