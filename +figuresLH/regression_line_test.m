classdef regression_line_test < matlab.unittest.TestCase
    
properties (TestParameter)
   weighted  =  {true, false}
end
    
   %methods (TestMethodSetup)
   %function x(testCase)
   %            
   %end
   %end
    

methods (Test)
   function oneTest(testCase, weighted)
      rng('default');
      a1 = 1.2;
      b1 = -0.34;

      n = 50;
      xV = rand([n, 1]);
      yV = a1 + b1 * xV + 0.1 .* randn([n,1]);
      
      if weighted
         wtV = 1 + rand([n, 1]);
         suffixStr = '_weighted';
      else
         wtV = [];
         suffixStr = '_unweighted';
      end

      %mdl = fitlm(xV, yV)
      
      fh = FigureLH('visible', false);
      fh.new;
      
      fh.plot_scatter(xV, yV, 1);
      [lineHandle, outStr] = figuresLH.regression_line(xV, yV, wtV);
      disp(outStr);
      text(mean(xV), mean(yV),  outStr);
      set(lineHandle, 'Color', 'r');
      
      hold off;
      
      compS = configLH.Computer([]);
      fh.save(fullfile(compS.testFileDir,  ['regression_line', suffixStr]), true);
   end
end

end