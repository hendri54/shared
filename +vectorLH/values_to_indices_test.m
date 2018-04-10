function tests = values_to_indices_test

tests = functiontests(localfunctions);

end

function oneTest(tS)
   numDigits = 7;

   rng('default');
   nv = 7;
   valueV = round(linspace(-5, 4, nv)', numDigits);
   n = 40;
   inV = valueV(randi(nv, [n, 1]));
   inV(5 : 5 : n) = NaN;
   
   dbg = 111;
   [outV, value2V] = vectorLH.values_to_indices(inV, numDigits, dbg);
   
   tS.verifyEqual(valueV, value2V(:));

   in2V = nan(size(inV));
   idxV = find(outV > 0);
   in2V(idxV) = valueV(outV(idxV));
   tS.verifyEqual(in2V, inV);
end