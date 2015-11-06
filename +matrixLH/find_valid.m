function vIdxV = find_valid(xM, missVal)
% Given a matrix, find rows with valid observations for all columns
%{
Valid means: non-nan and not missVal
%}

vIdxV = find(all(xM ~= missVal, 2)  &  all(~isnan(xM), 2));

end