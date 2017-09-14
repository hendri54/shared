function idxV = find_regressors_regex(mdl, patternStr, dbg)
% Find regressors that match a regex pattern
%{
IN
   mdl  ::  LinearModel
   patternStr  ::  char
      regex expression

OUT
   idxV  ::  integer
      indices into mdl.Coefficients
%}


[a,b] = regexp(mdl.CoefficientNames, patternStr, 'match', 'tokens');

assert(isequal(length(a),  length(mdl.CoefficientNames)),  'Expecting one result per coefficient');

idxV = find(~cellfun(@isempty,  a));


end