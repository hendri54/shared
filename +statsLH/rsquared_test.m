function tests = rsquared_test

tests = functiontests(localfunctions);

end


function oneTest(testCase)

% R^2 for weighted data
dbg = 111;
rng(323);
yV = linspace(-1, 1, 100);
yHatV = yV + randn(size(yV));
wtV = 1 + rand(size(yV));
statsLH.rsquared(yV, yHatV, wtV, dbg);


end