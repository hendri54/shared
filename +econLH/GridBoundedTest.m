function tests = GridBoundedTest

tests = functiontests(localfunctions);

end


function oneTest(testCase)

n = 9;
xMin = -0.9;
xMax = 0.3;

gS = econLH.GridBounded(n, xMin, xMax);

rng(904);
x1Ratio = rand(1);
dxV = rand(n-1, 1);
gridV = gS.make_grid(x1Ratio, dxV)

%keyboard;

end