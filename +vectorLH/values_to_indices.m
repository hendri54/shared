function [outV, valueV] = values_to_indices(inV, numDigits, dbg)
% Replace values in a vector with indices so that the smallest value becomes 1, the second smallest
% 2, etc
%{
NaN values in inV become zeros

IN
   inV  ::  numeric
      data vector to "recode"
   numDigits  ::  integer
      round to this many digits when determining unique values

OUT
   outV  ::  uint16
      recoded inV
%}

inV = round(inV, numDigits);
valueV = unique(inV(~isnan(inV)));

outV = zeros(size(inV), 'uint16');

for i1 = 1 : length(valueV)
   outV(inV == valueV(i1)) = i1;
end


end