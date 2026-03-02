function I = Invariants(CP,SD,State)


I0 = sum( sum( abs( SD.GammaMatrix + State.U ).^2 )) *SD.dx*SD.dy;
I1 = sum( diag(State.U) )*SD.dx;
I2 = sum( diag( unvec( SD.Nabla_x_minus_y* State.U(:), SD.N ) ))*SD.dx;
I3 = sum( diag(  (CP.q/CP.p) * State.U.^2 + unvec( (SD.Nabla_x_minus_y^2) * State.U(:), SD.N ) ))*SD.dx;

I=[I0; I1; I2; I3];

end