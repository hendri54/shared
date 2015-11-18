function [idxV, betaV] = dummy_pointers(mdl, varNameStr, valueV, dbg)
% Recover dummy coefficients from a linear model
%{
This really returns indices of all variables named (for example) 'age_i'
They don't have to be dummies

The entry for the omitted dummy is NaN

IN
   mdl
      linear model
   varNameStr
      variable name, e.g. 'age'
   valueV
      variable values for which dummies are sought

OUT
   idxV
      mdl.Coefficients.Estimate(idxV) holds coefficient estimates
%}

n = length(valueV);

idxV = nan([n, 1]);
betaV = nan([n, 1]);
for i1 = 1 : n
   vIdx = find(strcmp(mdl.CoefficientNames, sprintf('%s_%i', varNameStr, double(valueV(i1)))));
   if ~isempty(vIdx)
      idxV(i1) = vIdx;
      betaV(i1) = mdl.Coefficients.Estimate(vIdx);
   end
end

% Assume that first value is default (dummy = 0)
if isnan(betaV(1))
   betaV(1) = 0;
end



end