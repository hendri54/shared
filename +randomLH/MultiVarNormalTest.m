function tests = MultiVarNormalTest

tests = functiontests(localfunctions);

end


function oneTest(testCase)


%% Settings

dbg = true;
rng(41);
n = 4;
meanV = linspace(-1, 1, n)';
stdV  = rand(n, 1) * 2;
nObs = 1e6;


%% For many cases, test
if 0
   for i2 = 1 : 1e4
      mean2V = randn(n, 1) .* 10;
      std2V  = rand(n, 1) .* 10;
      % Multivariate normal object
      mS = randomLH.MultiVarNormal(mean2V, std2V);
      
      wtM = randn(n, n) .* 5;
      for i1 = 1 : n
         wtM(i1,i1) = 1;
         if i1 < n
            wtM(i1, (i1+1) : n) = 0;
         end
      end

      % Covariance matrix implied by wtM (matching stdV)
      cov_from_weights(mS, wtM, dbg);
   end
   
   % keyboard;
end


%% Test

for iCase = 1 : 2
   if iCase == 1
      % Default
   else
      % Case where one variable has 0 std deviation
      stdV(3) = 0;
   end

   mS = randomLH.MultiVarNormal(meanV, stdV);

   wtM = make_weight_matrix(stdV);


   % Make implied cov matrix (scaled)
   % covM = wtM * (wtM');
   covM = mS.cov_from_weights(wtM, dbg);


   % Check correlation coefficients implied by wtM
   %  Scaling wtM does not affect correlations
   [~, trueCorrM] = cov2corr(covM);
   [~, wtCorrM] = cov2corr(wtM * (wtM'));
   checkLH.approx_equal(trueCorrM, wtCorrM, 1e-4, []);


   % % Check that cholesky produces wtM
   % wt2M = chol(covM, 'lower');
   % checkLH.approx_equal(wtM, wt2M, 1e-6, []);


   % Draw random vars using built in function
   rng(121);
   % var3M = mvnrnd(meanV(:)',  covM,  nObs);
   var3M = mS.draw_given_weights(nObs, wtM, dbg);

   % Check marginal distributions
   checkLH.approx_equal(mean(var3M)', meanV, 5e-3, []);
   checkLH.approx_equal(std(var3M)', stdV, 5e-3, []);

   % Check correlation coefficients
   corr3M = corrcoef(var3M);
   checkLH.approx_equal(trueCorrM, corr3M, 5e-3, []);


   % Check cov matrix
   cov3M = cov(var3M);
   checkLH.approx_equal(covM, cov3M, 5e-3, []);

   % % Draw random vars
   % rng(12);
   % randM = randn(nObs, n);
   % varM = zeros(nObs, n);
   % for iVar = 1 : n
   %    varM(:, iVar) = randM * wtM(iVar,:)';
   % end
   % 
   % % Check that random variables drawn have correct cov matrix
   % cov2M = cov(varM);
   % % Surprisingly large gaps even for large numbers of observations
   % checkLH.approx_equal(covM, cov2M, 1e-2, []);
   % 
   % 
   % % Rescale the variables and check that correlations are unchanged
   % corrM = corrcoef(varM);
   % 
   % var2M = zeros(size(varM));
   % for iVar = 1 : n
   %    var2M(:,iVar) = (varM(:, iVar) - mean(varM(:,iVar))) ./ std(varM(:,iVar)) .* stdV(iVar) + meanV(iVar);
   % end
   % corr2M = corrcoef(var2M);
   % checkLH.approx_equal(corrM, corr2M, 1e-3, []);
end



end


%% Make lower triangular weight matrix
function wtM = make_weight_matrix(stdV)
   n = length(stdV);
   rng(94);
   wtM = 2 * randn(n,n);
   for i1 = 1 : n
      if i1 < n
         wtM(i1, (i1+1) : n) = 0;
      end
      if stdV(i1) == 0
         wtM(i1, :) = 0;
         wtM(:, i1) = 0;
      end
      % Diagonal elements are 1
      wtM(i1, i1) = 1;
   end
end


%% Test conditional distribution
function conditional_distrib_test(testCase)
   dbg = true;
   rng(41);
   n = 5;
   meanV = linspace(-1, 1, n)';
   stdV  = rand(n, 1) * 2;
   nObs = 1e4;
   
   mS = randomLH.MultiVarNormal(meanV, stdV);
   wtM = make_weight_matrix(stdV);
   covM = mS.cov_from_weights(wtM, dbg);
   
   idx2V = [2, 4];
   value2V = [0.5, -0.3];
   idx1V = 1 : n;
   idx1V(idx2V) = [];
   n1 = length(idx1V);
   mS.conditional_distrib(idx2V, value2V, covM, dbg);
   
   
   % ******  Check by simulation
   
   % Draw a sample
   rng(431);
   drawM = mvnrnd(mS.meanV(:)',  covM,  nObs);
   
   condMeanM = zeros(nObs, n1);
   condStdM  = zeros(nObs, n1);
   for i1 = 1 : nObs
      value2V = drawM(i1, idx2V);
      [condMeanM(i1,:), condStdM(i1,:)] = mS.conditional_distrib(idx2V, value2V, covM, dbg);
   end
   
   % Test with multiple inputs (tests matrix expansion)
   condMean2M = mS.conditional_distrib(idx2V, drawM(:, idx2V), covM, dbg);
   testCase.verifyEqual(condMean2M, condMeanM,  'AbsTol', 1e-5);
   
   for iVar = 1 : n1
      % Regress y against its conditional mean
      idx1 = idx1V(iVar);
      linModel = fitlm(condMeanM(:, iVar), drawM(:, idx1));
      betaV = linModel.Coefficients.Estimate;
      seBetaV = linModel.Coefficients.SE;
      
      % Test that intercept is 0 and slope is 1
      if any(abs(betaV(:) - [0;1]) > 2 * seBetaV(:))
         error('Wrong conditional means');
      end
      
      % Residuals
      residV = drawM(:, idx1) - condMeanM(:, iVar);
      std2 = std(residV);
      if abs(std2 - mean(condStdM(:, iVar))) > 1e-2
         error('Wrong conditional std dev');
      end
   end
end


%% Conditional mean weights
function cond_mean_weights_test(testCase)
   dbg = true;
   rng(41);
   n = 7;
   % With means of 0 and conditioning values of 1, we can compare
   % conditional means and weights for conditional means
   meanV = zeros(n, 1);
   stdV  = rand(n, 1) * 2;
   
   mS = randomLH.MultiVarNormal(meanV, stdV);
   wtM = make_weight_matrix(stdV);
   covM = mS.cov_from_weights(wtM, dbg);

   % Conditioning indices
   idx2V = [2, 4, 5];
   value2V = ones(size(idx2V));
   condMeanV = mS.conditional_distrib(idx2V, value2V, covM, dbg);
   % Compare with conditioning weights
   wtM = cond_mean_weights(mS, idx2V, covM, dbg);
   
   testCase.verifyEqual(condMeanV', sum(wtM, 2), 'AbsTol', 1e-4);
end

% ----------
