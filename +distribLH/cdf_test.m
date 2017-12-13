function tests = cdf_test

tests = functiontests(localfunctions);

end

function oneTest(testCase)
   dbg = 111;
   rng('default');
   dataV = 10 * randn([1e3, 1]);
   pctV = linspace(0.1, 0.1, 1);
   xV = distribLH.cdf(dataV, pctV, dbg);
   
   fracV = zeros(size(pctV));
   for i1 = 1 : length(pctV)
      fracV(i1) = sum(dataV <= xV(i1));
   end
   fracV = fracV ./ length(dataV);
   
   testCase.verifyEqual(fracV, pctV, 'AbsTol', 1e-3);
   
   pct2V = distribLH.cdf_inverse(dataV, xV, dbg);
   testCase.verifyEqual(pct2V, pctV, 'AbsTol', 1e-3);
end


%% Test with repeated observations
function repeatTest(testCase)
   dbg = 111;
   rng('default');
   dataV = 10 * randn([1e3, 1]);
   dataV(1 : 10 : 200) = mean(dataV);
   pctV = linspace(0.1, 0.1, 1);

   xV = distribLH.cdf(dataV, pctV, dbg);
      
   pct2V = distribLH.cdf_inverse(dataV, xV, dbg);
   testCase.verifyEqual(pct2V, pctV, 'AbsTol', 1e-3);
end