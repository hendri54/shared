function tests = figure_axes_same_test

tests = functiontests(localfunctions);

end

function oneTest(tS)
   % Set up test figures
   n = 3;
   for iFig = 1 : n
      fhV(iFig) = figure('visible', 'off');
      plot(iFig : (iFig + 10));
      axV(iFig) = gca;
   end
  
   % Make all axes same using figure handles
   axisV = [1, 5,  2, 6];
   axisV(3) = NaN;
   figuresLH.figure_axes_same(fhV, axisV);

   % To test NaN value, retrieve it from actual figure
   axisV(3) = axV(1).YLim(1);
   
   % Check that all axes match targets
   for iFig = 1 : n
      tS.verifyEqual(axV(iFig).XLim, axisV(1:2));
      tS.verifyEqual(axV(iFig).YLim, axisV(3:4));
   end
   
   % Same using axes handles
   figuresLH.figure_axes_same(axV, axisV);
   for iFig = 1 : n
      tS.verifyEqual(axV(iFig).XLim, axisV(1:2));
      tS.verifyEqual(axV(iFig).YLim, axisV(3:4));
   end
   
   close;
end