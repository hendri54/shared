function outM = sorted_indices(inM)
% Given a matrix, return vectors of all indices such that 
% inM(i1V(1), i2V(1)) is the smallest value and
% inM(i1V(end), i2V(end)) is the largest
%{
OUT
   outM  ::  double
      indices; each column is a dimension of inM
%}

% Sort the flattended matrix
[~, sortIdxV] = sort(inM(:));
% Make into indices
outM = matrixLH.ind2sub(size(inM), sortIdxV);  


end