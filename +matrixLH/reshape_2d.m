function outM = reshape_2d(A, j)
% Reshape a matrix into a 2D matrix such that
% outM(:,k) == A(:,:,k,:) where k is taken along dimension j
%{
Example:
   Take a matrix by [a,b,c]. Compute the sum along dimension b:
   sum(reshape_2d(A, 2))
%}

% Shiftdim so that dimension j is that last dimension in the matrix; then reshape
outM = reshape(shiftdim(A, j), [], size(A, j));


end