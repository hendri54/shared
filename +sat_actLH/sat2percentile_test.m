function tests = sat2percentile_test

tests = functiontests(localfunctions);

end


function oneTest(testCase)

satV = linspace(500, 1600, 100);
pctV = sat_actLH.sat2percentile(satV);

end