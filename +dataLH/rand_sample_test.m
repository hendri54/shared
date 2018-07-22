function tests = rand_sample_test

tests = functiontests(localfunctions);

end

function oneTest(tS)
   n = 50;
   nSample = 30;
   dbg = true;
   
   sIdxV = dataLH.rand_sample(n, nSample, dbg);
   
   assert(length(unique(sIdxV)) == nSample);
   assert(max(sIdxV) <= n);
   assert(min(sIdxV) >= 1);
end