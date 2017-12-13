function tests = NormalGridTest

tests = functiontests(localfunctions);

end

function oneTest(testCase)

   ng = 12;
   ubV = linspace(-2, 3, ng)';
   lb1 = -3;
   % Constructor
   ngS = distribLH.NormalGrid(lb1, ubV);
   ngS.dbg = 111;
   ngS.validate;

   % Access properties
   if ngS.ng ~= ng
      error('Invalid');
   end
   testCase.verifyEqual(ngS.lbV,  [lb1; ubV(1 : (end-1))],  'AbsTol', 1e-7);
   midV = ngS.midPointV;
   testCase.verifyEqual(midV - ngS.lbV,  ngS.ubV - midV,  'AbsTol', 1e-6);

   testCase.verifyEqual(ngS.edgeV, [lb1; ubV],  'AbsTol', 1e-7);
end



%% Set grid with uniform probabilities
function equal_prob_test(testCase)
   xMean = 2;
   xStd = 1.5;
   ng = 14;
   ngS = distribLH.NormalGrid(-1, [2, 3]);
   ngS.dbg = 111;
   
   ngS.set_grid_equal_prob(ng, xMean, xStd);
   mass3V = ngS.grid_mass(xMean, xStd);
   testCase.verifyEqual(mass3V,  ones(ng,1) ./ ng,  'AbsTol', 1e-4);


   % ***** Test mass by simulation

   rng(43);
   n = 1e5;
   xV = xMean + xStd .* randn(n, 1);

   edgeV = [min(xV) - 1; ngS.ubV];
   countV = histcounts(xV, edgeV);
   testCase.verifyEqual(mass3V, countV(:) ./ n,  'AbsTol', 5e-3);
end
