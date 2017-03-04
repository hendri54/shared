function tests = ParPoolLHtest
   tests = functiontests(localfunctions);
end

function oneTest(testCase)
   pS = ParPoolLH('nWorkers', 2);
   assert(isequal(pS.nWorkers, 2));
   pS = ParPoolLH;
   pS.close;
   assert(~pS.is_open);
   pS.maxWorkers;
   pS.open;
   assert(pS.is_open);
   pS.close;
end