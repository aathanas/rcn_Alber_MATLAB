function Phi = Phi_from_u(u)


[N,c]=size(u);
if N~=c
    error('matrix is not square')
end


PosDen=diag(u); % Extract its diagonal to form Phi^(-1/2)
PosDen=PosDen(:);
PosDen=real(PosDen);

Ry=repmat(PosDen,1,N);
Rx=repmat(PosDen',N,1);


Phi = Rx-Ry; 


end