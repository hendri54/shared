function regression_test_test(doShow)

disp('Testing regression_test');

if nargin < 1
   doShow = false;
end

rng(94);
n = 1e3;
trueM = randn(n, 1);
simM  = trueM + 0.3 .* randn(n, 1);

for useWeights = [false, true]
   if useWeights
      wtM = 1 + rand(n, 1);
   else
      wtM = [];
   end
   
   dev = econLH.regression_test(trueM, simM, wtM, doShow);

   assert(dev < 2.2);
end


end