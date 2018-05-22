% Weighted data class
%{
NaN observations are ignored
Zero weights are ignored
NaN  weights are treated like zero weights

NaN if there are no valid observations

For discrete data, it is typically better to use DiscreteData class

#todo: switch that governs how NaN are handled
%}
classdef WeightedDataLH < handle
   
properties
   dbg  logical = true;
end
   
properties (SetAccess = private)
   dataV    double
   % Weights
   wtV      double
   % Indicates which observations are valid
   validV   logical
   % Total weight of all valid observations
   totalWt  double
   % Sort indices; for valid obs only
   % Shorter than dataV. [] is no valid data
   sortIdxV double 
   
   % Fraction missing (weight of observations that are NaN)
   fracMiss  double
end


methods
   %% Constructor
   function wS = WeightedDataLH(dataV, wtV, dbg)
      if nargin >= 3
         wS.dbg = logical(dbg);
      end
      wS.dataV = dataV(:);
      % This implies that NaN weights are set to 0
      wS.wtV = max(0, wtV(:));

      % Fraction missing (data = NaN)
      wS.fracMiss = wS.weight_missing ./ sum(wS.wtV);
      
      wS.validV = ~isnan(wS.dataV)  &  (wS.wtV > 0);
      
      % Zero weight observations are ignored
      wS.wtV(~wS.validV) = 0;
      
      wS.totalWt = sum(wS.wtV);
      
      wS.sortIdxV = wS.sort_valid_observations;
      
      wS.validate;
   end

   
   %% Sort valid observations
   %{
   Should be dependent, but that is inefficient
   %}
   function sortedIdxV = sort_valid_observations(wS)
      nValid = sum(wS.validV);
      
      if nValid == 0
         sortedIdxV = [];
         
      elseif nValid == 1
         sortedIdxV = find(wS.validV, 1, 'first');
         
      else
         vIdxV = find(wS.validV);
         sortM = sortrows([wS.dataV(vIdxV), vIdxV]);
         sortedIdxV = sortM(:, 2);
      end
   end
   
   
   %% Validate
   function validate(wS)
      nValid = sum(wS.validV);
      if nValid > 0
         validateattributes(wS.dataV(wS.validV), {'double'}, {'finite', 'nonnan', 'nonempty', 'real'})
         validateattributes(wS.wtV(wS.validV), {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive'})
         % Sorted data must be increasing
         validateattributes(wS.dataV(wS.sortIdxV), {'double'}, {'finite', 'nonnan', 'nonempty', 'real', ...
            'nondecreasing'})
      end
   end
   
   

   %% Weight of missing observations
   %{
   Missing: dataV = NaN
   %}
   function wtMissing = weight_missing(wS)
      if any(isnan(wS.dataV))
         wtMissing = sum(wS.wtV .* isnan(wS.dataV));
      else
         wtMissing = 0;
      end
   end


   %% Weight of valid and missing observations
   function [wtSum, wtMissing] = weight_valid_missing(wS)
      if any(isnan(wS.dataV))
         missWt = sum(max(0, wS.wtV) .* isnan(wS.dataV));
         wtSum  = sum(max(0, wS.wtV));
         wS.fracMiss = missWt ./ wtSum;
      else
         wtSum = sum(wS.wtV);
         wtMissing = 0;
      end
   end


   %% Min
   %{
   OUT
      xMin  ::  double
         NaN if no valid data
   %}
   function xMin = min(wS)
      if wS.totalWt > 0
         xMin = wS.dataV(wS.sortIdxV(1));
      else
         xMin = NaN;
      end
   end
   
   
   %% Mean
   function xMean = mean(wS)
      vIdxV = find(wS.validV);
      if ~isempty(vIdxV)
         xMean = sum(wS.dataV(vIdxV) .* wS.wtV(vIdxV)) ./ wS.totalWt;      
      else
         xMean = NaN;
      end
   end
   
   
   %% Mean and std dev
   function [xVar, xMean] = var(wS)
      vIdxV = find(wS.validV);
      if ~isempty(vIdxV)
         xMean = sum(wS.dataV(vIdxV) .* wS.wtV(vIdxV)) ./ wS.totalWt;
         xVar  = sum(((wS.dataV(vIdxV) - xMean) .^ 2)  .* wS.wtV(vIdxV)) ./ wS.totalWt;
      else
         xMean = NaN;
         xVar = NaN;
      end
   end
   
   
   %% Mean and std for log
   % Drops observations <= 0
   function [xVar, xMean] = var_log(wS)
      vIdxV = find(wS.validV  &  wS.dataV > 0);
      if ~isempty(vIdxV)
         logDataV = log(wS.dataV(vIdxV));
         wt1V = wS.wtV(vIdxV) ./ sum(wS.wtV(vIdxV));
         xMean = sum(logDataV .* wt1V);
         xVar  = sum(((logDataV - xMean) .^ 2)  .* wt1V);
      else
         xMean = NaN;
         xVar = NaN;
      end
   end
   
   
   %% Median
   %{
   Max observation below cumulative mass 0.5
   No interpolation, but can use quantiles for that
   %}
   function xMedian = median(wS)
      if wS.totalWt > 0
         % Sorted percentiles
         pctV = min(1, cumsum(wS.wtV(wS.sortIdxV)) ./ wS.totalWt);
         idxMedian = find(pctV <= 0.5, 1, 'last');
         xMedian = wS.dataV(wS.sortIdxV(idxMedian));
   %       idxMedian = find(wS.percentile_positions <= 0.5, 1, 'last');
   %       xMedian = wS.
         validateattributes(xMedian, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'scalar'})
      else
         xMedian = NaN;
      end
   end
   
   
   %% Quantiles (cdf)
   %{
   Uses interpolation
   Built in QUANTILE command cannot handle weighted data
   %}
   function qV = quantiles(wS, pctUbV)
      qV = interp1(min(1, cumsum(wS.wtV(wS.sortIdxV)) ./ wS.totalWt),  wS.dataV(wS.sortIdxV),  ...
         pctUbV,  'linear');
   end
   
   
   %% Quantile indices
   %{
   IN
      pctV  ::  double
         percentiles to look for
   OUT
      idxV  ::  double
         index values into dataV 
         dataV(idxV(i1)) is the smallest dataV point with percentile position >= pctV(i1)
   %}
   function qIdxV = quantile_indices(wS, pctV)
      dPctV = wS.percentile_positions;
      qIdxV = zeros(size(pctV));
      
      for i1 = 1 : length(pctV)
         % All points above desired percentile (never [])
         idxV = find(dPctV >= pctV(i1));
         [~, idx1] = min(dPctV(idxV));
         qIdxV(i1) = idxV(idx1);
      end
   end
   
   
   %% Assign each data point its percentile position in the cdf
   %{
   This produces odd results for data with repeated values (not the same percentile positions for
   the same values)
   
   OUT
      pctV  ::  double
         pctV(i1)  = cumulative weight of all dataV <= dataV(i1)
         First data point gets its own weight
         NaN for invalid obs
   %}
   function pctV = percentile_positions(wS)
      pctV = nan(size(wS.dataV));
      if wS.totalWt > 0
         pctV(wS.sortIdxV) = min(1, cumsum(wS.wtV(wS.sortIdxV)) ./ wS.totalWt);
         % Avoid rounding errors for top point
         pctV(wS.sortIdxV(end)) = 1;

         validateattributes(pctV(wS.validV), {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive', '<=', 1})
         validateattributes(pctV(wS.sortIdxV), {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'increasing', 'positive'})
      end
   end
   
   
   
   %% Inverse cdf of the data in dataV
   %{
   Inverse of quantiles
   Repeated observations: add a tiny amount of noise

   IN
      pointV  ::  double
         data points to look up

   OUT
      pctV  ::  double
         percentile position of each point in the cdf
         NaN if out of range
   %}
   function pctV = cdf_inverse(wS, pointV)
      if all(wS.dataV(wS.sortIdxV) > eps)
         % Values are unique
         pctV = interp1(wS.dataV(wS.sortIdxV),  cumsum(wS.wtV(wS.sortIdxV)) ./ wS.totalWt,  pointV(:));
      else
         % Need to add "noise"
         pctV = interp1(wS.dataV(wS.sortIdxV) + (1 : length(wS.sortIdxV))' .* (5 * eps),  ...
            cumsum(wS.wtV(wS.sortIdxV)) ./ wS.totalWt,  pointV(:));
      end
      
      % If a point is very close to lowest data point, avoid numerical issues
      idxV = abs(pointV - wS.dataV(wS.sortIdxV(1))) < 1e-12;
      if ~isempty(idxV)
         pctV(idxV) = wS.wtV(wS.sortIdxV(1)) ./ wS.totalWt;
      end
      
      if wS.dbg
         validateattributes(pctV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'nonnegative', ...
            '<=', 1})
      end
   end
   
   
   %% Percentile positions for data with repeated values
   %{
   Given data with repeated values (a limited number)
   Assign the obs with the smallest value the mass of that value
   Assign the obs with the 2nd smallest value the mass of values 1 and 2; etc
   %}
   function pctV = pct_positions_repeated(wS)
      pctV = nan(size(wS.dataV));

      if wS.totalWt > 0
         % List of values (sorted) and fractions
         [valueListV, valueFracV] = values_weights(wS);
         cumFracV = cumsum(valueFracV);
         cumFracV(end) = 1;

         % Assign to groups
         groupV = zeros(size(wS.dataV));
         vIdxV = find(wS.validV);
         groupV(vIdxV) = discretize(wS.dataV(vIdxV), [valueListV(1)-1; valueListV(:) + 1e-4]);

         for i1 = 1 : length(valueListV)
            pctV(groupV == i1) = cumFracV(i1);
         end

         validateattributes(pctV(vIdxV), {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive', '<=', 1})
      end
   end
end
   
   
end