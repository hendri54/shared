% Weighted data class
%{
NaN observations are ignored
Zero weights are ignored

NaN if there are no valid observations
%}
classdef WeightedDataLH < handle
   
properties
   dataV    double
   % Weights
   wtV      double
   validV   logical
   % Total weight of all valid observations
   totalWt  double
   % Sort indices; for valid obs only
   % Shorter than dataV
   sortIdxV double 
   
   % Fraction missing (weight of observations that are NaN)
   fracMiss  double
end


methods
   %% Constructor
   function wS = WeightedDataLH(dataV, wtV)
      wS.dataV = dataV(:);
      wS.wtV = wtV(:);
      wS.implied;
   end

   
   %% Implied properties
   %{
   Should be dependent, but that is inefficient
   %}
   function implied(wS)
      n = length(wS.dataV);
      % Total weight before dropping missing values
      % wtSum = sum(max(0, wS.wtV));
      % Weight of missing observations
      if any(isnan(wS.dataV))
         missWt = sum(max(0, wS.wtV) .* isnan(wS.dataV));
         wtSum  = sum(max(0, wS.wtV));
         wS.fracMiss = missWt ./ wtSum;
      else
         %missWt = 0;
         wS.fracMiss = 0;
      end
      
      wS.validV = ~isnan(wS.dataV)  &  (wS.wtV > 0);
      vIdxV = find(wS.validV);
      % assert(length(vIdxV) > 2,  'Too few observations');
      
      if length(vIdxV) >= 2
         wS.totalWt = sum(wS.wtV(vIdxV));

         % Zero weights for missing values
         wS.wtV(~wS.validV) = 0;
         wS.dataV(~wS.validV) = nan;

         % Sort order
         % Nan values are placed last
         sortM = sortrows([wS.dataV, (1 : n)', wS.validV]);
         % Keep the valid obs (sortM(:,3) = true)
         wS.sortIdxV = sortM(find(sortM(:,3)), 2);


         % Output check
         validateattributes(wS.dataV(wS.validV), {'double'}, {'finite', 'nonnan', 'nonempty', 'real'})
         validateattributes(wS.wtV(wS.validV), {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive'})
         % Sorted data must be increasing
         validateattributes(wS.dataV(wS.sortIdxV), {'double'}, {'finite', 'nonnan', 'nonempty', 'real', ...
            'nondecreasing'})
      else
         wS.totalWt = 0;
      end
   end
   
   
%    %% Fraction missing
%    function fracMiss = frac_missing(wS)
%       if all(wS.wtV > 0)
%          fracMiss = 0;
%       else
%          fracMiss = 1 - sum(wS.wtV(wS.wtV >= 0)) ./ wS.totalWt;
%       end
%    end
   
   
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
   
   
   %% Median
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
   
   
   %% Assign each data point its percentile position in the cdf
   %{
   First data point gets its own weight
   NaN for invalid obs
   This produces odd results for data with repeated values (not the same percentile positions for
   the same values)
   %}
   function pctV = percentile_positions(wS)
      pctV = nan(size(wS.dataV));
      if wS.totalWt > 0
         pctV(wS.sortIdxV) = min(1, cumsum(wS.wtV(wS.sortIdxV)) ./ wS.totalWt);

         validateattributes(pctV(wS.validV), {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive', '<=', 1})
         validateattributes(pctV(wS.sortIdxV), {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'increasing', 'positive'})
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