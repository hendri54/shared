function tests = predict_select_regressors_test

tests = functiontests(localfunctions);

end

function oneTest(tS)
   rng('default');
   n = 50;
   regressorV = {'x1', 'x2', 'x3'};
   nRegr = length(regressorV);
   betaV = 1 : nRegr;
   xM = randn(n, nRegr);
   
   tbM = table;
   for ir = 1 : nRegr
      tbM.(regressorV{ir}) = xM(:,ir);
   end
   tbM.y = randn(n, 1);
   for ir = 1 : nRegr
      tbM.y = tbM.y + betaV(ir) .* tbM.(regressorV{ir});
   end
   mdl = fitlm(tbM,  'y ~ x1 + x2 + x3');
   beta0 = mdl.Coefficients.Estimate(1);
   betaEstV = mdl.Coefficients.Estimate(2 : end);
   
   % Vary one regressor
   regressorsToVaryV = regressorV(2);
   yV = regressLH.predict_select_regressors(mdl, tbM, regressorsToVaryV);
   tS.verifyEqual(size(yV), [n,1]);
   tS.verifyTrue(~any(isnan(yV)));
   
   y2V = beta0 + betaEstV(1) .* mean(tbM.x1) + betaEstV(2) .* tbM.x2 + betaEstV(3) .* mean(tbM.x3);
   tS.verifyEqual(y2V, yV, 'AbsTol', 1e-5);
   
   % Vary two regressors
   regressorsToVaryV = regressorV(2:3);
   yV = regressLH.predict_select_regressors(mdl, tbM, regressorsToVaryV);
   tS.verifyEqual(size(yV), [n,1]);
   tS.verifyTrue(~any(isnan(yV)));
   
   y2V = beta0 + betaEstV(1) .* mean(tbM.x1) + betaEstV(2) .* tbM.x2 + betaEstV(3) .* tbM.x3;
   tS.verifyEqual(y2V, yV, 'AbsTol', 1e-5);  
end


%% Categorical regressor
function categoricalTest(tS)
   rng('default');
   n = 50;
   regressorV = {'x1', 'x2', 'x3'};
   nRegr = length(regressorV);
   betaV = 1 : nRegr;
   xM = randn(n, nRegr);
   
   tbM = table;
   for ir = 1 : nRegr
      tbM.(regressorV{ir}) = xM(:,ir);
   end
   
   tbM.y = randn(n, 1);
   for ir = 1 : nRegr
      tbM.y = tbM.y + betaV(ir) .* tbM.(regressorV{ir});
   end
   
   tbM.x2 = discretize(tbM.x2, -0.5 : 0.5 : 1.5, 'categorical');
   mdl = fitlm(tbM,  'y ~ x1 + x2 + x3')
   
   % Vary one regressor
   regressorsToVaryV = regressorV(2);
   yV = regressLH.predict_select_regressors(mdl, tbM, regressorsToVaryV);
   tS.verifyEqual(size(yV), [n,1]);

   % Vary two regressors
   regressorsToVaryV = regressorV(2:3);
   yV = regressLH.predict_select_regressors(mdl, tbM, regressorsToVaryV);
   tS.verifyEqual(size(yV), [n,1]);
end