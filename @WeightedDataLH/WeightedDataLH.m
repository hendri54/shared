% Weighted data class
%{
%}
classdef WeightedDataLH < handle
   
properties
   dataV    double
   % Weights
   wtV      double
   validV   logical
   totalWt  double
   % Sort indices; for valid obs only
   % Shorter than dataV
   sortIdxV double 
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
      wS.validV = ~isnan(wS.dataV)  &  (wS.wtV > 0);
      vIdxV = find(wS.validV);
      
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
      pctV(wS.sortIdxV) = min(1, cumsum(wS.wtV(wS.sortIdxV)) ./ wS.totalWt);
      
      validateattributes(pctV(wS.validV), {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive', '<=', 1})
      validateattributes(pctV(wS.sortIdxV), {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'increasing', 'positive'})
   end
   
   
   %% Percentile positions for data with repeated values
   %{
   Given data with repeated values (a limited number)
   Assign the obs with the smallest value the mass of that value
   Assign the obs with the 2nd smallest value the mass of values 1 and 2; etc
   %}
   function pctV = pct_positions_repeated(wS)
      % List of values (sorted) and fractions
      [valueListV, valueFracV] = values_weights(wS);
      cumFracV = cumsum(valueFracV);
      cumFracV(end) = 1;
      
      % Assign to groups
      groupV = zeros(size(wS.dataV));
      vIdxV = find(wS.validV);
      groupV(vIdxV) = discretize(wS.dataV(vIdxV), [valueListV(1)-1; valueListV(:) + 1e-4]);
      
      pctV = nan(size(wS.dataV));
      for i1 = 1 : length(valueListV)
         pctV(groupV == i1) = cumFracV(i1);
      end
      
      validateattributes(pctV(vIdxV), {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive', '<=', 1})
   end
end
   
   
end