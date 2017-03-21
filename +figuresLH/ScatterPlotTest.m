function tests = ScatterPlotTest

tests = functiontests(localfunctions);

end

function oneTest(testCase)
   xV = rand(100,1);
   yV = xV - xV .^ 2 + rand(100,1);

   spS = figuresLH.ScatterPlot([], 'visible', true);
   spS.plot(xV, yV);
end