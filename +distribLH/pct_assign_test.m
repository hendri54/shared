classdef pct_assign_test < matlab.unittest.TestCase
    
properties (TestParameter)
   weighted = {false, true}
end

methods (Test)
   function oneTest(testCase, weighted)
      rng('default');
      dbg = 111;

      n = 30;
      if weighted
         weightV = rand([1, n]);
         weightV = weightV ./ sum(weightV);
      else
         weightV = [];
      end
      xV = rand([1, n]);

      pctV = distribLH.pct_assign(xV, weightV, dbg);

      if ~weighted
         weightV = ones(size(xV));
      end
      
      totalWt = sum(weightV);
      pct2V = zeros(size(pctV));
      for i1 = 1 : length(xV)
         pct2V(i1) = sum(weightV .* (xV <= xV(i1))) ./ totalWt;
      end

      testCase.verifyEqual(pct2V, pctV, 'AbsTol', 1e-6)
   end
      
end

end

