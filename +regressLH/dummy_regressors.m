function tbM = dummy_regressors(mdl, varNameStr, dbg)
% Given a LinearModel that contains dummy variables of the form `xyz_123`
% make a table with the dummy values (123 in this example) and regression coefficients
%{
IN
   varNameStr  ::  char
      the part before `_123` in the CoefficientName
OUT
   tbM  ::  table with fields
      Estimate
      SE
      tStat
      pValue
      These are the fields in `Estimate` from the `LinearModel`
      dummyValue
         the `123` parts of the dummy variables
%}

% Find positions of all regressors
%idxV = regressLH.regressors_by_name(mdl, [varNameStr, '_'], dbg);
% Only regressors that START with varNameStr and END with '123'
idxV = regressLH.find_regressors_regex(mdl, ['^', varNameStr, '_(\d+)$'], dbg);


if isempty(idxV)
   tbM = [];
   return;
end


% Table with coefficients and their std errors
tbM = mdl.Coefficients(idxV,:);

% Isolate the dummy values (e.g. 123) and add them to the table
n = size(tbM, 1);
tbM.dummyValue = nan(n, 1);

% Extract the trailing digits from the row names (of the form varNameStr_123)
% It would be more robust to replace this with a loop so one can check that the RowNames have the
% expected format
[~, b] = regexp(tbM.Properties.RowNames,  [varNameStr, '_(\d+)$'], 'match', 'tokens');
assert(length(b) == n);

% Make them numeric
for i1 = 1 : n
   assert(all(ismember(b{i1}{1}{1}, '0123456789')));
   tbM.dummyValue(i1) = str2double(b{i1}{1}{1});
end

validateattributes(tbM.dummyValue, {'double'}, {'finite', 'nonnan', 'nonempty', 'integer', '>=', 0})
assert(length(tbM.dummyValue) == length(unique(tbM.dummyValue)),  'Dummy values not unique');

% Remove row names
tbM.Properties.RowNames = {};


end