function tests = find_regressors_test

tests = functiontests(localfunctions);

end


function oneTest(testCase)
% Really just a syntax test. The code is so direct that any test would simply repeat it

dbg = 111;

mdl = regressLH.make_test_model;

varNameStrV = {'cat1_2', 'cat2_2', 'var1', 'var2'};

[idxV, betaV] = regressLH.find_regressors(mdl, varNameStrV, dbg);
validateattributes(betaV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'size', [length(varNameStrV), 1]})

if ~isempty(testCase)
   verifyTrue(testCase,  isa(betaV, 'double'));
end


end