function [idxV, betaV] = regressors_by_name(mdl, varNameStr, dbg)
% Find regressors by name in a LinearModel
%{
The match is limited for first N characters (the length of varNameStr)
E.g., looking for 'exper' also returns 'exper^2'

If regressors not found: return []

IN
   mdl
      linear model
   varNameStr
      variable name, e.g. 'age'

OUT
   idxV
      mdl.Coefficients.Estimate(idxV) holds coefficient estimates
   betaV
      point estimates
%}

assert(isa(varNameStr, 'char'));

idxV = find(strncmp(mdl.CoefficientNames, varNameStr, length(varNameStr)));
if isempty(idxV)
   betaV = [];
else
   betaV = mdl.Coefficients.Estimate(idxV);
end

end