function tests = common_axis_limits_test

tests = functiontests(localfunctions);

end

function oneTest(tS)
   nFig = 3;
   xMin = 1e8;
   xMax = -1e8;
   yMin = 1e8;
   yMax = -1e8;
   
   for iFig = 1 : nFig
      xV = iFig + (1 : 5);
      fV(iFig) = figure('visible', 'off');
      plot(xV);
      axV(iFig) = gca;
      
      ax = gca;
      xMin = min([ax.XLim, xMin]);
      xMax = max([ax.XLim, xMax]);
      yMin = min([ax.YLim, yMin]);
      yMax = max([ax.YLim, yMax]);      
   end
   
   [x1V, y1V] = figuresLH.common_axis_limits(fV, []);
   [x2V, y2V] = figuresLH.common_axis_limits(axV, []);
   
   for iFig = 1 : nFig
      close(fV(iFig));
   end
   
   tS.verifyEqual(x1V, x2V);
   tS.verifyEqual(y1V, y2V);
   tS.verifyEqual(x1V, [xMin, xMax])
   tS.verifyEqual(y1V, [yMin, yMax])
end