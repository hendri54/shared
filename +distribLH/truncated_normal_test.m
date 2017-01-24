function tests = truncated_normal_test

tests = functiontests(localfunctions);

end


function allTest(testCase)

dbg = 111;
xMean = 0.3;
xStd = 2;
rng(13);

% Scalar or vector inputs
for n = [1, 3]
   % Different truncations
   for iCase = 1 : 3
      if n == 1
         xLb = -1;
         xUb = 1.5;
      else
         xLb = linspace(-1, 0.5, n);
         xUb = xLb + linspace(1.1, 0.3, n);
      end

      switch iCase
         case 1
            % default
         case 2
            xLb = [];
         case 3
            xUb = [];
         otherwise
            error('Invalid');
      end

      [meanL, varL] = distribLH.truncated_normal(xMean, xStd, xLb, xUb, dbg);


      % Test by simulating
      for ix = 1 : n
         xV = xMean + xStd .* randn([5e5, 1]);
         if ~isempty(xLb)
            xV(xV < xLb(ix)) = [];
         end
         if ~isempty(xUb)
            xV(xV > xUb(ix)) = [];
         end

         checkLH.approx_equal(mean(xV),  meanL(ix),  1e-2,  []);
         checkLH.approx_equal(std(xV),  varL(ix) ^ 0.5,  1e-2,  []);

   %    fprintf('Mean: %5.3f  true: %5.3f    std: %5.3f  true: %5.3f   N: %i \n', ...
   %       meanL, mean(xV),  varL ^ 0.5, std(xV),  length(xV));
      end
   end
end


end