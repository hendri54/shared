function tests = sequential_bounded_test

tests = functiontests(localfunctions);

end

function oneTest(testCase)
   outV = integerLH.sequential_bounded(1 : 6, 3);
   assert(isequal(outV, [1:3, 1:3]));
end


