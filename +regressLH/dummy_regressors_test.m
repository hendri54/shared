function tests = dummy_regressors_test

tests = functiontests(localfunctions);

end


function oneTest(testCase)

   dbg = 111;
   [mdl, modelS] = regressLH.make_test_model;

   tbM = regressLH.dummy_regressors(mdl, 'cat1', dbg);

   % Check a regression coefficient
   idx1 = find(strcmp(mdl.CoefficientNames, 'cat1_2'));
   beta1 = mdl.Coefficients.Estimate(idx1);
   idx1a = find(tbM.dummyValue == 2);
   testCase.verifyEqual(beta1, tbM.Estimate(idx1a), 'AbsTol', 1e-5);

   % Check a std error
   idx1 = find(strcmp(mdl.CoefficientNames, 'cat1_3'));
   beta1 = mdl.Coefficients.SE(idx1);
   idx1a = find(tbM.dummyValue == 3);
   testCase.verifyEqual(beta1, tbM.SE(idx1a), 'AbsTol', 1e-5);

end


%% Test that interactions are not retrieved
function interactionTest(testCase)
   dbg = 111;
   n = 50;
   rng('default');
   tbM = table((1 : n)',  randi(5, [n, 1]), rand(n, 1),  'VariableNames', {'y', 'x1', 'x2'});
   mdl = fitlm(tbM, 'y ~ x1*x2', 'CategoricalVars', {'x1'});
   
   tbM = regressLH.dummy_regressors(mdl, 'x1', dbg);

   testCase.verifyEqual(tbM.dummyValue,  (2:5)');
   
   idx1 = find(strcmp(mdl.CoefficientNames, 'x1_3'));
   beta1 = mdl.Coefficients.Estimate(idx1);
   idx1a = find(tbM.dummyValue == 3);
   testCase.verifyEqual(beta1, tbM.Estimate(idx1a), 'AbsTol', 1e-5);
   
end