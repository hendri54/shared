function outM = matrix_from_indices(valueM, ind1M, ind2M, ind3M)
% Given a matrix of values and a matrix of indices, return a matrix with values for all index
% combinations in indM
%{
There should be a way to extend this to N dimensional matrices
%}

nd = nargin - 1;

switch nd
   case 2
      idxV = sub2ind(size(valueM),  ind1M(:), ind2M(:));
      outM = reshape(valueM(idxV),  size(ind1M));
   case 3
      idxV = sub2ind(size(valueM),  ind1M(:), ind2M(:), ind3M(:));
      outM = reshape(valueM(idxV),  size(ind1M));
   otherwise
      error('Invalid');
end


end