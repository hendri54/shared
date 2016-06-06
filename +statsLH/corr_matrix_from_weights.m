function corrM = corr_matrix_from_weights(wtM)
% Make a valid correlation matrix from a matrix of weights
%{
This is useful for calibrating model correlation matrices

Expect the matrix of weights to be of the form
[1 b c;  0 1 e;  0 0 1]
%}

%% Input check

n = size(wtM, 1);
validateattributes(wtM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'size', [n, n]})
assert(all(abs(diag(wtM) - 1) < 1e-8));


%% Main

xM = wtM' * wtM;
yM = diag(diag(xM)) ^ (-0.5);
% This normalizes the diagonal elements to 1
corrM = yM * xM * yM;


%% Output check

validateattributes(corrM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', '>=', -1.0001, '<=', 1.0001, ...
   'size', [n,n]})

% Avoid numerical issues for diagonal elements
for i1 = 1 : n
   corrM(i1,i1) = 1;
end


end