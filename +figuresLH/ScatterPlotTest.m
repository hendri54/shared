function tests = ScatterPlotTest

tests = functiontests(localfunctions);

end

function oneTest(testCase)
   lhS = const_lh;
   
   xV = rand(100,1);
   yV = xV - xV .^ 2 + rand(100,1);
   xV(3) = NaN;
   yV(10) = NaN;

   spS = figuresLH.ScatterPlot([], 'visible', false);
   spS.ignoreNan = true;
   
   spS.plot(xV, yV);
   spS.format;
   spS.save(fullfile(lhS.dirS.testFileDir,  'ScatterPlotTest'), true);
   % spS.close;
end