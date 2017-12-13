function tests = common_input_sizes_test

tests = functiontests(localfunctions);

end

function oneTest(testCase)
   sizeV = {[1,2,3], [1,1], [1,2,3]};
   [commonSizeV, isScalarV] = functionLH.common_input_sizes(sizeV);
   testCase.verifyEqual(commonSizeV, [1,2,3]);
   testCase.verifyEqual(isScalarV, [false, true, false]);
end


function scalarTest(testCase)
   sizeV = {[1,1], [1,1]};
   [commonSizeV, isScalarV] = functionLH.common_input_sizes(sizeV);
   testCase.verifyEqual(commonSizeV, [1,1]);
   testCase.verifyEqual(isScalarV, [true, true]);
end


function noScalarTest(testCase)
   sizeV = {[1,2,3], [1,2,3], [1,2,3]};
   [commonSizeV, isScalarV] = functionLH.common_input_sizes(sizeV);
   testCase.verifyEqual(commonSizeV, [1,2,3]);
   testCase.verifyEqual(isScalarV, [false, false, false]);

end