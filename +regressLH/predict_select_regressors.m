% Predict from linear regression mdl
% Hold all regressors constant, except those in regressorsToVaryV
%{
Main purpose is to be used with dummy regressors where retrieving coefficients is not easy

IN
   mdl  ::  LinearModel
   tbM  ::  table
      contains all variables required by mdl
   regressorsToVaryV  ::  cell array of char
%}
function yV = predict_select_regressors(mdl, tbM, regressorsToVaryV)

tb2M = tbM;
n = size(tbM, 1);

regressorV = mdl.PredictorNames;
for i1 = 1 : length(regressorV)
   regrName = regressorV{i1};
   if ~ismember(regrName, regressorsToVaryV)
      regrValue = make_fixed_value(tbM.(regrName));
      tb2M.(regrName) = repmat(regrValue,  [n, 1]);
      assert(isequal(class(tbM.(regrName)),  class(tb2M.(regrName))));
   end
end

yV = predict(mdl, tb2M);

end


%% Make fixed value for a regressor
function regrValue = make_fixed_value(xV)
   xClass = class(xV);
   if isa(xV, 'logical')
      regrValue = true;
   elseif isa(xV, 'numeric')
      regrValue = cast(nanmean(xV), xClass);
   elseif isa(xV, 'categorical')
      catV = categories(xV);
      regrValue = catV{1};
   else
      error('Invalid');
   end
   assert(isequal(class(regrValue), xClass));
end