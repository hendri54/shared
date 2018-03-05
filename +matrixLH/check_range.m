function outM = check_range(inM, xRangeV, xTol)
% Check that matrix is inside a range subject to a tolerance
% Truncate elements outside of the range
%{
Main purpose: deal with numerical inaccuracies

Drawback: copies the matrix. Inefficient for large matrices

NaN values result in errors

IN
   inM  ::  numeric
   xRangeV  ::  numeric
      range of acceptable values
   xTol  ::  numeric
      tolerance; values outside of xRangeV +/- xTol give error
%}

assert(all(inM(:) >= xRangeV(1) - xTol),  'Min value %f < %f',  min(inM(:)), xRangeV(1));
assert(all(inM(:) <= xRangeV(2) + xTol),  'Max value %f > %f',  max(inM(:)), xRangeV(2));
outM = max(xRangeV(1), min(xRangeV(2), inM));


end