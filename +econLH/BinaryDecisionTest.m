function tests = BinaryDecisionTest

tests = functiontests(localfunctions);

end


%% Check one case
function oneTest(testCase)
   rng('default');
   v1 = 1.8;
   v2 = 1.4;
   sigmaP = 0.7;
   
   bS = econLH.BinaryDecision(sigmaP);
   prob1V = bS.prob1(v1, v2);
   euV = bS.expected_utility(v1, v2);
   
   [prob1, eV] = simulate(v1, v2, [], sigmaP);
   checkLH.approx_equal(prob1, prob1V, 1e-2, [], 'Differences in probs');
   
   checkLH.approx_equal(eV, euV, [], 1e-2, 'Differences in means');
end


%% Check lots of cases
function manyTest(testCase)
   rng('default');
   n = 20;
   v1V = randn(n, 1);
   v2V = randn(n, 1);
   sigmaP = 0.5;
   
   bS = econLH.BinaryDecision(sigmaP);
   prob1V = bS.prob1(v1V, v2V);
   
   euV = bS.expected_utility(v1V, v2V);
   
   % Test by simulation
   rng(20);
   nSim = 1e5;
   pV = randn(nSim, 1) * sigmaP;
   
   for i1 = 1 : n
      [prob1, meanValue] = simulate(v1V(i1), v2V(i1), pV, sigmaP);
      
      % Check probability
      checkLH.approx_equal(prob1V(i1),  prob1,  1e-2,  []);
   
      % Check expected value
      checkLH.approx_equal(meanValue,  euV(i1),  1e-2,  []);
   end
end


%% Prob and expected value by sim
function [prob1, eV] = simulate(v1, v2, pV, sigmaP)
   if isempty(pV)
      rng(20);
      nSim = 1e5;
      pV = randn(nSim, 1) * sigmaP;
   else
      nSim = length(pV);
   end
   
   % Probability
   idx1V = find(v1 > v2 + pV);
   prob1 = length(idx1V) ./ nSim;
   
   % Expected value
   valueV = max(repmat(v1, [nSim, 1]),  v2 + pV);
   eV = mean(valueV);
end