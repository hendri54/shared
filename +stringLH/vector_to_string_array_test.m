function tests = vector_to_string_array_test

tests = functiontests(localfunctions);

end

function oneTest(testCase)
   outV = stringLH.vector_to_string_array([1 2 3], 'x%iy');
   for i1 = 1 : length(outV)
      assert(isequal(outV{i1},  sprintf('x%iy', i1)));
   end
end


