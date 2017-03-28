function tests = cdf_weighted_test

tests = functiontests(localfunctions);

end


function oneTest(testCase)

disp('Test cdf_weighted');
dbg = 111;
rng(32);

n = 1e2;

xInV = linspace(0, 1, n)';
wtInV = 1 + rand(n, 1);

idxV = randperm(n);

for isWeighted = [true, false]
   if isWeighted
      wtV = wtInV(idxV);
   else
      wtV = [];
   end
   [cumPctV, xV, cumTotalV] = distribLH.cdf_weighted(xInV(idxV), wtV, dbg);

   % Compare
   if isWeighted
      checkLH.approx_equal(cumPctV,  cumsum(wtInV) ./ sum(wtInV), 1e-3, []);
   else
      checkLH.approx_equal(cumPctV,  (1/n : 1/n : 1)', 1e-3, []);
   end
   checkLH.approx_equal(xV, xInV, 1e-6, []);
end

end