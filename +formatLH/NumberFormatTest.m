function tests = NumberFormatTest

tests = functiontests(localfunctions);

end

function oneTest(testCase)
   nfS = formatLH.NumberFormat('groupSeparator', ',',  'nDecimals', 3);
   
   inM = [12345, 123.45; 0.12345, 0.0012345];
   tgM = {'12,345.000',  '123.450';  '0.123',  '0.001'};
   outM = nfS.format(inM);
   testCase.verifyEqual(outM, tgM);
   
   nfS = formatLH.NumberFormat('currency', true);
   tgM = {'12,345.00',  '123.45';  '0.12',  '0.00'};
   outM = nfS.format(inM);
   testCase.verifyEqual(outM, tgM);
   
end