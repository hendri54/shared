classdef ClassifiedDataTest < matlab.unittest.TestCase
    
properties (TestParameter)
   % NaN values in data?
   hasNan = {false, true}
   % Omit nan in computation
   omitNan = {false, true}
end
   

methods (Test)
   %% Test class means
   function meanTest(testCase, hasNan, omitNan)
      rng('default');
      nc = 5;
      nObs = 50;
      xV = randn([nObs, 1]);
      wtV = rand([nObs, 1]);
      classV = randi(nc, [nObs, 1]);
      cdS = dataLH.ClassifiedData(nc);
      cdS.omitNaN = omitNan;
      cdS.dbg = 111;
      
      if hasNan
         xV(5 : 5 : nObs) = NaN;
      end
      
      meanV = cdS.class_means(xV, wtV, classV);
      
      % Test the long way
      mean2V = nan([cdS.nClasses, 1]);
      for ic = 1 : cdS.nClasses
         if omitNan
            idxV = find(classV == ic  &  ~isnan(xV));
         else
            idxV = find(classV == ic);
         end
         if ~isempty(idxV)
            mean2V(ic) = sum(xV(idxV) .* wtV(idxV)) ./ sum(wtV(idxV));
         end
      end

      testCase.verifyEqual(mean2V, meanV, 'RelTol', 1e-6);
   end
   
   
   %% Test means from bounds
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
      
      [yMeanV, xMeanV] = cdS.means_from_bounds(yV, xV, wtV, ubV);
      
      if omitNan  ||  ~hasNan
         validateattributes(xMeanV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'increasing', ...
            'size', [nc, 1]});

         testCase.verifyEqual(yMeanV, xMeanV, 'RelTol', 1e-2);
      end
   end

end
end