function EOC = ExperimetalOrderConvergence(dof,err)
% returns the experimental order of convergence
% dof: the number of degrees of freedom used in each computation OR the
% step size (both are supported)
% err: the error in each computation

if length(dof)~=length(err)
    error('Invalid input (dof and err must have same lengths)')
elseif length(dof)<2
    error('Not enough runs to extract EOC')
end


EOC(1)=0;

if ~all( dof == flip(sort(dof)) ) && ~all( dof == sort(dof) )
    error('Invalid dof vector; cannot compute EOC')
end


if dof == flip(sort(dof)) % decreasing entries means its really step size, not dof
    dof = flip(dof);
end

for jj=2:length(dof)
    EOC(jj) = - log(err(jj-1)/err(jj))/log(dof(jj-1)/dof(jj));
end


EOC=EOC(:);
end