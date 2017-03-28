function tests = dummy_pointers_test

tests = functiontests(localfunctions);

end


function oneTest(testCase)

dbg = 111;
[mdl, modelS] = regressLH.make_test_model;

[idxV, betaV] = regressLH.dummy_pointers(mdl, 'cat1', [2, 3], dbg);

idx1 = find(strcmp(mdl.CoefficientNames, 'cat1_2'));
beta1 = mdl.Coefficients.Estimate(idx1);

idx2 = find(strcmp(mdl.CoefficientNames, 'cat1_3'));
beta2 = mdl.Coefficients.Estimate(idx2);

checkLH.approx_equal(betaV(:),  [beta1; beta2],  1e-8,  []);
assert(isequal(idxV(:),  [idx1; idx2]));

validateattributes(betaV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real'})

% Logical
varName = modelS.boolS.varNameV{1};
[idxV, betaV] = regressLH.dummy_pointers(mdl, varName, 1, dbg);
checkLH.approx_equal(betaV, modelS.boolS.coeffV(1),  1e-2, []);


if ~isempty(testCase)
   verifyTrue(testCase,  isa(betaV, 'double'));
end


end