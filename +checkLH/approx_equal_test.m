function tests = approx_equal_test

tests = functiontests(localfunctions);

end

function oneTest(testCase)
   rng('default');
   
   sizeV = [4, 3, 2];
   x1M = randn(sizeV);
   x2M = x1M + 1e-6 .* randn(sizeV);
   
   % Check absolute tolerance
   result1 = checkLH.approx_equal(x1M, x2M, 1e-5, [], 'Abs tolerance check');
   testCase.verifyTrue(result1);    % ,  'Wrong answer for abs tolerance')
   
   % Check when absolute tolerance fails
   result2 = checkLH.approx_equal(x1M, x2M, 1e-7, [], 'Abs tolerance check');
   testCase.verifyTrue(~result2);
end