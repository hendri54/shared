function tests = PiecewiseLinearTest

tests = functiontests(localfunctions);

end

function Test(testCase)
   rng('default');
   n = 5;
   slopeV = randn([n, 1]);
   cutoffV = cumsum(10 .* rand([n-1, 1]));
   intercept = randn([1, 1]);
   
   fS = functionLH.PiecewiseLinear(slopeV, cutoffV, intercept);
   fS.validate;
   
   nSim = 500;
   xV = (cutoffV(end) + 2) .* rand(nSim, 1);
   
   % Function values
   yV = fS.value(xV);
   
   % Intercept
   checkLH.approx_equal(fS.value(0), intercept, 1e-6, []);
   
   % Slopes
   slope1V = fS.slope(xV);
   dx = 1e-6;
   y2V = fS.value(xV + dx);
   slope2V = (y2V - yV) ./ dx;
   checkLH.approx_equal(slope1V, slope2V, 1e-6, []);
end