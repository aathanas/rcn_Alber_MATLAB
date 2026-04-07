function Phi = Phi_from_u(u)
%% Compute the constraint field Phi from the solution matrix U.
%
%  Phi = Phi_from_u(u)
%
%  Phi(i,j) = u(i,i) - u(j,j)  (position density difference).
%  The result is real by construction.

[N, c] = size(u);
if N ~= c
    error('[Phi_from_u] Matrix is not square.');
end

PosDen = real(diag(u));
PosDen = PosDen(:);

Phi = PosDen' - PosDen;  % broadcasts to N x N

end
