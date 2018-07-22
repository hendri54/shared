function tests = max_test

tests = functiontests(localfunctions);

end

function oneTest(tS)
   nr = 4;
   nc = 3;
   m = linspace(2, 3, nr)' * linspace(1, 2, nc);
   
   rMax = 2;
   cMax = 3;
   m(rMax, cMax) = 100;
   
   [maxVal, idxV] = matrixLH.max(m, true);
   tS.verifyEqual(maxVal, m(rMax, cMax));
   tS.verifyEqual(idxV(:), [rMax; cMax]);
   
   m(rMax+1, cMax) = NaN;
   [maxVal2, idx2V] = matrixLH.max(m, true);
   tS.verifyEqual(maxVal2, maxVal);
   tS.verifyEqual(idx2V, idxV);
   
   [maxVal3, idx2V] = matrixLH.max(m, false);
   tS.verifyTrue(isnan(maxVal3));
end