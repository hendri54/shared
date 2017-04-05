function tests = mean_weighted_test

tests = functiontests(localfunctions);

end

function oneTest(testCase)
   dbg = 111;
   rng('default');
   sizeV = [9, 5];
   xM = randn(sizeV);
   wtM = rand(sizeV);
   
   avg = statsLH.mean_weighted(xM, wtM, dbg);
   checkLH.approx_equal(sum(xM(:) .* wtM(:)) ./ sum(wtM(:)),  avg,  1e-7,  []);
   
   avg2 = statsLH.mean_weighted(xM, zeros(size(xM)), dbg);
   assert(isnan(avg2));
end