function [idxV, betaV] = dummy_pointers(mdl, varNameStr, valueV, dbg)
% Recover dummy coefficients from a linear model
%{
This really returns indices of all variables named (for example) 'age_i'
They don't have to be dummies

The entry for the omitted dummy is 0

IN
   mdl
      linear model
      for dummies, always expect variables of the form x_1 (for first value of x)
   varNameStr
      variable name, e.g. 'age'
   valueV
      variable values for which dummies are sought
      may be integer (e.g. quartiles) or logical

OUT
   idxV
      mdl.Coefficients.Estimate(idxV) holds coefficient estimates
      for logical: just the one for true
%}

% n = length(valueV);

assert(isa(valueV, 'numeric'));

% if isa(valueV, 'logical')
%    % Return the 'true' dummy
%    varNameV = {[varNameStr, '_true']};
% else
   % Return dummies for numerical values
   varNameV = string_lh.vector_to_string_array(valueV,  [varNameStr, '_%i']);
% end


[idxV, betaV] = regressLH.find_regressors(mdl, varNameV);

% idxV = nan([n, 1]);
% betaV = nan([n, 1]);
% for i1 = 1 : n
%    vIdx = find(strcmp(mdl.CoefficientNames, sprintf('%s_%i', varNameStr, double(valueV(i1)))));
%    if ~isempty(vIdx)
%       idxV(i1) = vIdx;
%       betaV(i1) = mdl.Coefficients.Estimate(vIdx);
%    end
% end

% Assume that first value is default (dummy = 0)
if isnan(betaV(1))  &&  isa(valueV, 'numeric')
   betaV(1) = 0;
end

% validateattributes(betaV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real'})

end