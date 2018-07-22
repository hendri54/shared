% Set matrix diagonal to a vector or scalar
%{
Must work when diagonal elements are NaN
%}
function outM = set_diagonal(inM, diagV)

assert(ismatrix(inM));

n = size(inM, 1);
outM = inM;
outM(1 : (n+1) : end) = diagV(:) .* ones(n, 1);

% .* (~eye(size(inM))) + diag(diagV(:) .* ones(n, 1));

end