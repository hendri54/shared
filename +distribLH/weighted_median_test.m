function tests = weighted_median_test

tests = functiontests(localfunctions);

end


%% Main test
function oneTest(testCase)

   n = 1e2;
   rng(54);
   xV = randn(1, n);
   wtV = 0.01 + rand([1,n]);
   totalWt = sum(wtV);
   dbg = 111;

   md = distribLH.weighted_median(xV, wtV, dbg);

   lowFrac = sum(wtV(xV <= md)) ./ sum(wtV);
   if lowFrac > 0.50001
      error('lowFrac too high');
   end

   % Find the next higher value
   xSortV = sort(xV);
   if any(diff(xSortV) < 1e-7)
      error('This fails');
   end
   idxV = find(xSortV > md + 1e-8);
   xNext = xSortV(idxV(1));
   highFrac = sum(wtV(xV >= xNext)) ./ totalWt;
   if highFrac < 0.5
      error('highFrac too high');
   end
end




%% Speed test
% function speed_test(testCase)
%    disp('Speed test');
% 
%    n = 1e4;
%    xV = 1 + randn(n, 1);
%    wtV = 1 + rand(n, 1);
%    dbg = 0;
% 
%    tic
%    distribLH.weighted_median(xV, wtV, dbg);
%    toc
% end
