function [idxV, betaV] = find_regressors(mdl, varNameStrV, dbg)
% Find regressors by name in a LinearModel
%{
The match is limited for first N characters (the length of varNameStrV{i1})
E.g., looking for 'exper' also returns 'exper^2'

If regressor not found: return NaN

IN
   mdl
      linear model
   varNameStrV
      variable names, e.g. 'age'

OUT
   idxV
      mdl.Coefficients.Estimate(idxV) holds coefficient estimates
%}

if isa(varNameStrV, 'char')
   varNameStrV = {varNameStrV};
end

n = length(varNameStrV);

idxV = nan([n, 1]);
betaV = nan([n, 1]);
for i1 = 1 : n
   vIdx = find(strcmp(mdl.CoefficientNames, varNameStrV{i1}));
   if ~isempty(vIdx)
      idxV(i1) = vIdx;
      betaV(i1) = mdl.Coefficients.Estimate(vIdx);
   end
end

end