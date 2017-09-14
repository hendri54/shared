function tests = ScatterPlotTest

tests = functiontests(localfunctions);

end

function oneTest(testCase)
   spS = figuresLH.ScatterPlot([], 'visible', false);
   spS.ignoreNan = true;
   
   [xV, yV] = data_generation;
   spS.plot(xV, yV);
   spS.format;

   compS = configLH.Computer([]);
   spS.save(fullfile(compS.testFileDir,  'ScatterPlotTest'), true);
   % spS.close;
end


%% Weighted data
function weightedTest(testCase)
   spS = figuresLH.ScatterPlot([], 'visible', false);
   spS.ignoreNan = true;
   
   [xV, yV, wtV] = data_generation;
   spS.plot(xV, yV, wtV);
   spS.format;

   compS = configLH.Computer([]);
   spS.save(fullfile(compS.testFileDir,  'ScatterPlotTestWeighted'), true);
   % spS.close;
end


%% Data generation
function [xV, yV, wtV] = data_generation
   rng('default');
   xV = rand(100,1);
   yV = xV - xV .^ 2 + rand(100,1);
   xV(3) = NaN;
   yV(10) = NaN;
   wtV = rand(100, 1);
end