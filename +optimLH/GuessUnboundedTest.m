function tests = GuessUnboundedTest

tests = functiontests(localfunctions);

end


function oneTest(testCase)

rng(324);
n = 5;
xMinV = linspace(-1e3, 1e2, n);
xMaxV = xMinV + linspace(1e2, 10, n);
valueV = xMinV + (xMaxV - xMinV) .* rand(size(xMinV));

gS = optimLH.GuessUnbounded(xMinV, xMaxV);

guessV = gS.guesses(valueV);

value2V = gS.values(guessV);

checkLH.approx_equal(value2V, valueV, 1e-5, []);

end