function tests = uniquecell_test

tests = functiontests(localfunctions);

end

function oneTest(testCase)
   % Note that row and column vectors are treated as the same
   % Matrices are flattened
   x = {[1,2,3], [1,2,3,4], 4, [1;2;3;4], [1;2;3], [1,3;2,4]};
   y = {[1,2,3], [1,2,3,4], 4};
   
   z = cellLH.uniquecell(x);
   
   % Sort order could be different
   testCase.verifyEqual(y, z);
end