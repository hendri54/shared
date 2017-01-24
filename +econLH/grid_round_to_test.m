function tests = grid_round_to_test

tests = functiontests(localfunctions);

end


function one_test(testCase)

dbg = 111;

ng = 5;
gridV = linspace(-1.9, 2.1, ng);

for iCase = 1 : 2
   rng('default');
   n = 60;
   if iCase == 1
      xV = linspace(gridV(1) - 1,  gridV(ng) + 1,  n);
   elseif iCase == 2
      % x inside the grid
      xV = linspace(gridV(2) + 1e-5,  gridV(ng-1) - 1e-5,  n);
   else
      error('Invalid');
   end
   xV = xV(randperm(n));

   [xIdxV, xGridV] = econLH.grid_round_to(xV, gridV, dbg);


   % Test
   for i = 1 : n
      if xV(i) <= gridV(1)
         assert(xIdxV(i) == 1, 'Lower bound not assigned to 1');

      elseif xV(i) >= gridV(ng)
         assert(xIdxV(i) == ng, 'Upper bound not assigned to ng');

      else
         % Interior point
         % Find first grid point larger than xV(i)
         g = find( gridV > xV(i), 1, 'first' );
         % Distances from surrounding grid points
         distUp = abs( xV(i) - gridV(g) );
         distDn = abs( xV(i) - gridV(g-1) );
         % Distance to assigned grid point
         dist = abs(xV(i) - xGridV(i));
         assert(dist < min(distUp, distDn) + 1e-8,  'Invalid grid assignment');
      end
   end
end

end
