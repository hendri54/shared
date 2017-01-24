function tests = BinaryDecisionTest

tests = functiontests(localfunctions);

end

function Test(testCase)
   n = 9;
   v1V = randn(n, 1);
   v2V = randn(n, 1);
   sigmaP = 0.5;
   
   bS = econLH.BinaryDecision(sigmaP);
   prob1V = bS.prob1(v1V, v2V);
   
   euV = bS.expected_utility(v1V, v2V);
   
   % Test by simulation
   rng(20);
   nSim = 1e4;
   pV = randn(nSim, 1) * sigmaP;
   idx1V = find(v1V(1) > v2V(1) + pV);
   checkLH.approx_equal(prob1V(1),  length(idx1V) ./ nSim,  1e-2,  []);
   
   valueV = max(repmat(v1V(1), [nSim, 1]),  v2V(1) + pV);
   meanValue = mean(valueV);
   checkLH.approx_equal(meanValue,  euV(1),  1e-2,  []);
end