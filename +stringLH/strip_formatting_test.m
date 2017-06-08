function tests = strip_formatting_test

tests = functiontests(localfunctions);

end

function oneTest(testCase)
   inV = {'this is <strong> correct', 'also correct', 'also</strong> true'};
   trueV = {'this is  correct', 'also correct', 'also true'};
   outV = stringLH.strip_formatting(inV);
   testCase.verifyEqual(outV, trueV);
end