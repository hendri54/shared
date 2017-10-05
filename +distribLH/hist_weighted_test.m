function tests = hist_weighted_test

tests = functiontests(localfunctions);

end

function oneTest(testCase)
   dbg = 111;
   n = 100;
   rng('default');
   xV = randn(n, 1);
   wtV = rand(n, 1);
   binEdgeV = -0.5 : 0.1 : 0.5;
   nBins = length(binEdgeV) - 1;
   
   xV(10) = binEdgeV(2);
   xV(20) = binEdgeV(end);
   
   massV = zeros(nBins, 1);
   for i1 = 1 : nBins
      massV(i1) = sum(wtV(xV > binEdgeV(i1)  &  xV <= binEdgeV(i1+1)));
   end
   
   [countV, midV] = distribLH.hist_weighted(xV, wtV, binEdgeV, dbg);
   
   testCase.verifyEqual(countV(:), massV(:), 'AbsTol', 1e-5);
end