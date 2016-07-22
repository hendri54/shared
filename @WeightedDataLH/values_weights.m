function [valueListV, valueFracV] = values_weights(wS)
% Given weighted data with repeated observations: find values and their mass
%{
Handle cases where values are similar but not identical (numerical issues)
%}

% List of values (rounded to 4 digits
valueV = round(wS.dataV(wS.validV), 4);
[valueListV, ~, idxV] = unique(valueV);

% Mass of each value
vMassV = accumarray(idxV, wS.wtV(wS.validV), size(valueListV), @sum);
valueFracV = vMassV ./ sum(vMassV);

end