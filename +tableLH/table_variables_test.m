function tests = table_variables_test

tests = functiontests(localfunctions);

end

function oneTest(testCase)
   bothV = {'a', 'b', 'c', 'd', 'e', 'f', 'g'};
   bothIdxV = [2,3];
   tbIdxV = [4,7];
   tbNameV = bothV([tbIdxV, bothIdxV]);
   vnIdxV = [1,5];
   varNameV = bothV([vnIdxV, bothIdxV]);
   
   tbM = array2table(rand(5, length(tbNameV)),  'VariableNames', tbNameV);
   
   [inBothV, inTableV, inVarNameV] = tableLH.table_variables(tbM, varNameV);
   
   testCase.verifyEqual(inBothV,  bothV(bothIdxV));
   testCase.verifyEqual(inTableV,  bothV(tbIdxV));
   testCase.verifyEqual(inVarNameV,  bothV(vnIdxV));
   
end