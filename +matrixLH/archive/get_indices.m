function idxM = get_indices(m)
% Get indices such that idxM(:,j) is a matrix with the j-dimension index for each element of m(:)
%{
The main purpose is to display a matrix "flattened"

Given 2D m, use
idxM = get_indices(m)
disp([idxM, m])
to display: row index, col index, value
%}


sizeV = size(m);
nd = length(sizeV);

switch nd
   case 2
      [x1, x2] = ndgrid(1 : sizeV(1),  1 : sizeV(2));
      idxM = [x1(:), x2(:)];
   case 3
      [x1, x2, x3] = ndgrid(1 : sizeV(1),  1 : sizeV(2),  1 : sizeV(3));
      idxM = [x1(:), x2(:), x3(:)];
   otherwise
      error('Not implemented')
end




end