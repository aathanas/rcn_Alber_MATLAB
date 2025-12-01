function I = Invariants(CP,SD,State)



I1=trapz( diag(State.U) )*SD.dx;
I2 = trapz( diag( unvec( SD.Nabla_x_minus_y* State.U(:), SD.N ) ))*SD.dx;
I3 = trapz( diag(  (CP.q/CP.p) * State.U.^2 + unvec( (SD.Nabla_x_minus_y^2) * State.U(:), SD.N ) ))*SD.dx;

I=[I1; I2; I3];

end