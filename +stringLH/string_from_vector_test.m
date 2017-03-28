function tests = string_from_vector_test

tests = functiontests(localfunctions);

end


function oneTest(testCase)

outStr = stringLH.string_from_vector([1.234 3.456 4.780], '%.2f');

assert(isequal(outStr,  '1.23, 3.46, 4.78'));

end