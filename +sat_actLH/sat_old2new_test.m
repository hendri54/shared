function tests = sat_old2new_test

tests = functiontests(localfunctions);

end


function oneTest(testCase)

newV = sat_actLH.sat_old2new(linspace(400, 1590, 50));
validateattributes(newV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive', 'size', [1,50]})

end