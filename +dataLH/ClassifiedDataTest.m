classdef ClassifiedDataTest < matlab.unittest.TestCase
    
properties (TestParameter)
   % NaN values in data?
   hasNan = {false, true}
   % Omit nan in computation
   omitNan = {false, true}
end
   

methods (Test)
   %% Test class means and std deviations
   function meanTest(testCase, hasNan, omitNan)
      rng('default');
      dbg = 111;
      nc = 5;
      nObs = 50;
%       yV = linspace(1, 2, nObs)' + randn([nObs,1]);
      wtV = rand([nObs, 1]);
      classV = randi(nc, [nObs, 1]);
      xV = randn([nObs, 1]) + classV;
      cdS = dataLH.ClassifiedData(nc);
      cdS.omitNaN = omitNan;
      cdS.dbg = 111;
      
      if hasNan
         xV(5 : 5 : nObs) = NaN;
%          yV(6 : 6 : nObs) = NaN;
      end
      
      meanV = cdS.class_means(xV, wtV, classV);
      [xStdV, xMeanV] = cdS.class_std(xV, wtV, classV);
      
      testCase.verifyEqual(meanV, xMeanV, 'RelTol', 1e-4);
      
      % Test the long way
      mean2V = nan([cdS.nClasses, 1]);
      xStd2V = nan([cdS.nClasses, 1]);
      for ic = 1 : cdS.nClasses
         if omitNan
            idxV = find(classV == ic  &  ~isnan(xV));
         else
            idxV = find(classV == ic);
         end
         if ~isempty(idxV)  &&  ~any(isnan(xV(idxV)))
            [xStd2V(ic), mean2V(ic)] = statsLH.std_w(xV(idxV),  wtV(idxV), dbg);
         end
      end

      testCase.verifyEqual(mean2V, meanV, 'RelTol', 1e-6);
      testCase.verifyEqual(xStd2V, xStdV, 'RelTol', 1e-5);
   end
   
   
   %% Test means from bounds and class assignment
   function meansFromBoundsTest(testCase, hasNan, omitNan)
      rng('default');
      nObs = 15000;
      xV = randn([nObs, 1]);
      yV = xV + 0.2 .* randn([nObs, 1]);
      wtV = 1 + rand([nObs, 1]);
      ubV = 0.25 : 0.25 : 1;
      nc = length(ubV);
      
      if hasNan
         xV(100 : 100 : nObs) = NaN;
      end
      
      cdS = dataLH.ClassifiedData(nc);
      cdS.omitNaN = omitNan;
      cdS.dbg = 111;
      
      classV = cdS.assign_classes(xV, wtV, ubV);
      [yMeanV, xMeanV] = cdS.means_from_bounds(yV, xV, wtV, ubV);
      
      % Test class assignment
      if omitNan  ||  ~hasNan
         massV = zeros(nc, 1);
         xMean2V = nan(nc, 1);
         yMean2V = nan(nc, 1);
         for ic = 1 : nc
            massV(ic) = sum(wtV(classV == ic));
            xMean2V(ic) = sum(xV(classV == ic) .* wtV(classV == ic)) ./ massV(ic);
            yMean2V(ic) = sum(yV(classV == ic) .* wtV(classV == ic)) ./ massV(ic);
         end
         massV = massV ./ sum(massV);
         testCase.verifyEqual(cumsum(massV),  ubV(:),  'AbsTol', 1e-3,  'Class masses wrong');
         testCase.verifyEqual(xMeanV,  xMean2V,  'AbsTol', 1e-3,  'x means wrong');
         testCase.verifyEqual(yMeanV,  yMean2V,  'AbsTol', 1e-3,  'y means wrong');

         validateattributes(xMeanV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'increasing', ...
            'size', [nc, 1]});

         testCase.verifyEqual(yMeanV, xMeanV, 'RelTol', 1e-2);
      else
         testCase.verifyTrue(all(isnan(classV)));
         testCase.verifyTrue(all(isnan(xMeanV)));
         testCase.verifyTrue(all(isnan(yMeanV)));
      end
   end

end
end