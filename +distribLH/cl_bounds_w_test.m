function tests = cl_bounds_w_test

tests = functiontests(localfunctions);

end


function oneTest(testCase)

dbg = 111;
rng(409);

pctUbV = linspace(0.2, 1, 6);
n = 100;

for isWeighted = [true, false]
   xIn = randn(n, 1);
   if isWeighted
      wtIn = rand(n, 1);
      xUbV = distribLH.cl_bounds_w(xIn, wtIn, pctUbV, dbg);
   else
      wtIn = ones(n, 1);
      xUbV = distribLH.cl_bounds_w(xIn, [], pctUbV, dbg);
   end
   
   sortM = sortrows([xIn(:), wtIn(:)]);
   cumWtV = cumsum(sortM(:,2)) ./ sum(wtIn(:));
   
   for i1 = 1 : length(pctUbV)
      % Highest obs below upper bound
      idx1 = find(cumWtV <= pctUbV(i1), 1, 'last');

      % It is in the class
      assert(sortM(idx1,1) <= xUbV(i1) + 1e-8);
      if idx1 < n
         % The next obs is in a higher class
         assert(sortM(idx1 + 1, 1) > xUbV(i1))
      end

      % Lowest obs in class
      if i1 > 1
         idx2 = find(cumWtV > pctUbV(i1 - 1), 1, 'first');
         % It is in the class
         assert(sortM(idx2,1) > xUbV(i1 - 1));
         if idx2 > 1
            % It is in a lower class
            assert(sortM(idx2-1, 1) <= xUbV(i1 - 1) + 1e-8);
         end
      end

      % Fraction of observations below upper bound
      frac = sum(wtIn .* (xIn <= xUbV(i1))) ./ sum(wtIn);
      if i1 > 1
         assert(frac >= pctUbV(i1-1));
      end
      if i1 < length(pctUbV)
         assert(frac <= pctUbV(i1));
      end
   end
end

end