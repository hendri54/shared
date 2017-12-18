function tests = NormalDistributionTest

tests = functiontests(localfunctions);

end


%% Points on cdfs
function cdfTest(testCase)
   rng('default');
   
   nk = 5;
   nj = 7;
   ubV = linspace(-2, 2, nk);
   meanV = linspace(-2, 2, nj);
   stdV = linspace(0.9, 0.2, nj);
   
   nS = distribLH.NormalDistribution;
   nS.dbg = 111;
   
   probM = nS.cdf(ubV, meanV, stdV);
   
   nDraw = 1e4;
   prob2M = zeros(size(probM));
   for j = 1 : nj
      xV = meanV(j) + stdV(j) .* randn([nDraw, 1]);
      countV = histcounts(xV, [-100; ubV(:)]);
      countV = cumsum(countV);
      prob2M(j,:) = countV ./ nDraw;      
   end
   
   dev = econLH.regression_test(probM(:), prob2M(:), [], false);
   testCase.verifyTrue(abs(dev) < 2);
end


%% Probability of being in ranges
function rangeTest(testCase)
   rng('default');
   
   nk = 5;
   nj = 7;
   ubV = linspace(-2, 2, nk);
   meanV = linspace(-2, 2, nj);
   stdV = linspace(0.9, 0.2, nj);
   
   nS = distribLH.NormalDistribution;
   nS.dbg = 111;
   
   probM = nS.range_probs(ubV, meanV, stdV);
   
   nDraw = 1e4;
   prob2M = zeros(size(probM));
   for j = 1 : nj
      xV = meanV(j) + stdV(j) .* randn([nDraw, 1]);
      countV = histcounts(xV, [-100; ubV(:)]);
      prob2M(j,:) = countV ./ nDraw;      
   end
   
   dev = econLH.regression_test(probM(:), prob2M(:), [], false);
   testCase.verifyTrue(abs(dev) < 2);
end