function tests = regressors_by_name_test

tests = functiontests(localfunctions);

end


function oneTest(testCase)
% Really just a syntax test. The code is so direct that any test would simply repeat it

dbg = 111;

mdl = regressLH.make_test_model;

trueV = {'cat2_2', 'cat2_3', 'cat2_4'};

[idxV, betaV] = regressLH.regressors_by_name(mdl, 'cat2', dbg);

validateattributes(betaV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'size', [length(trueV), 1]})

testCase.verifyEqual(trueV, mdl.CoefficientNames(idxV));

end