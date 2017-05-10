function tests = WeightedDataLHtest

tests = functiontests(localfunctions);

end


function oneTest(testCase)

rng(450)
n = 3000;
dataV = randn(n, 1) .* 10;
wtV   = rand(n, 1) .* 10;
wtV(wtV > 9) = 0;
dataV(wtV > 8  &  wtV < 9.5) = nan;

vIdxV = find(~isnan(dataV)  &  (wtV > 0));

wS = WeightedDataLH(dataV, wtV);

validateattributes(wS.dataV(wS.validV), {'double'}, {'finite', 'nonnan', 'nonempty', 'real'})
validateattributes(wS.wtV(wS.validV), {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive'})

% Sorted data must be increasing
validateattributes(wS.dataV(wS.sortIdxV), {'double'}, {'finite', 'nonnan', 'nonempty', 'real', ...
   'increasing'})

pctV = wS.percentile_positions;

% pct_positions_repeated_test
% values_weights_test;

% Median
xMedian = wS.median;
massBelow = sum(wtV(vIdxV) .* (dataV(vIdxV) <= xMedian));
massAbove = sum(wtV(vIdxV) .* (dataV(vIdxV) > xMedian));
checkLH.approx_equal(massBelow ./ (massAbove + massBelow), 0.5, 1e-3, []);

% Std dev
xStd = wS.var .^ 0.5;
trueStd = statsLH.std_w(dataV(vIdxV), wtV(vIdxV), 111);
checkLH.approx_equal(xStd, trueStd, 1e-3, []);

end


%% Testing assignment of percentile positions (repeated data)
function pct_positions_repeated_test(testCase)
   rng(44);
   
   n = 100;
   % Group fractions
   ng = 4;
   fracV = linspace(1, 2, ng);
   fracV = fracV ./ sum(fracV);
   % Group values
   valueV = linspace(3, 10, ng);
   % No of obs in each group
   ubNV = round(linspace(10, round(0.8*n), ng));
   lbNV = [1, ubNV+1];
   
   % Make data (still sorted)
   dataV = nan(n, 1);
   wtV   = rand(n, 1) .* 2;
   for ig = 1 : ng
      idxV = lbNV(ig) : ubNV(ig);
      dataV(idxV) = valueV(ig);
      wtV(idxV) = fracV(ig) ./ length(idxV);
   end

   % Random permutation
   idxV = randperm(n);
   
   wS = WeightedDataLH(dataV(idxV), wtV(idxV));
   [valueListV, valueFracV] = wS.values_weights;
   checkLH.approx_equal(valueListV(:), valueV(:), 1e-4, []);
   checkLH.approx_equal(valueFracV(:), fracV(:),  1e-4, []);
   
   pctV = wS.pct_positions_repeated;
   for ig = 1 : ng
      gIdxV = find(dataV(idxV) == valueV(ig));
      assert(all(abs(pctV(gIdxV) - sum(fracV(1:ig))) < 1e-4));
   end
end


%% Testing values_weights
function values_weights_test(testCase)
   n = 100;
   dataV = round(randn(n, 1) .* 10, 3);
   wtV = rand(n, 1) .* 10;
   wtV(wtV > 9) = 0;
   dataV(wtV > 8  &  wtV < 9.5) = nan;

   vIdxV = find(wtV > 0  &  ~isnan(dataV));
   valueListV = unique(dataV(vIdxV));
   valueFracV = zeros(size(valueListV));
   for i1 = 1 : length(valueListV)
      idxV = find(dataV == valueListV(i1)  &  wtV > 0);
      valueFracV(i1) = sum(wtV(idxV));
   end
   valueFracV = valueFracV ./ sum(valueFracV);
   
   wS = WeightedDataLH(dataV, wtV);
   [valueList2V, valueFrac2V] = wS.values_weights;
   checkLH.approx_equal(valueList2V, valueListV, 1e-5, []);
   checkLH.approx_equal(valueFrac2V, valueFracV, 1e-5, []);

end