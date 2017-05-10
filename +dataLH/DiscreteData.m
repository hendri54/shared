% Data that takes on discrete numeric values
%{
For efficiency: do not store data and weights in object
%}
classdef DiscreteData < handle
      
properties
   % Permissible values
   valueV = []
   % Value labels (for summary table)
   valueLabelV  cell = []
   % Missing value codes
   missValCodeV = []
   % Weighted data?
   weighted  logical = true
end

methods
   %% Constructor
   function dS = DiscreteData(varargin)
      functionLH.varargin_parse(dS, varargin);
   end

   
   %% Figure out list of discrete values from data
   function value_list(dS, inV, wtV)
      validV = ~isnan(inV);
      if ~isempty(dS.missValCodeV)
         validV(ismember(inV, dS.missValCodeV)) = false;
      end
      if dS.weighted
         validV(wtV <= 0) = false;
      end
      
      dS.valueV = unique(inV(validV));
   end
   
   
   %% Frequency table
   %{
   OUT:
      countV  ::  uint64
         counts how often each value occurs
      fracV
         fraction of total weight in each class
   %}
   function [countV, fracV] = freq_table(dS, inV, wtV)
      if isempty(dS.valueV)
         dS.value_list(inV, wtV);
      end
      nv = length(dS.valueV);
      assert(nv > 0);
      assert(nv < 1e4,  'Too many discrete values');
      
      countV = zeros(size(dS.valueV), 'uint64');
      fracV  = zeros(size(countV));
      for i1 = 1 : nv
         countV(i1) = sum(inV == dS.valueV(i1));
         if dS.weighted
            fracV(i1)  = sum((inV == dS.valueV(i1)) .* max(0, wtV));
         end
      end
      
      if dS.weighted
         fracV = fracV ./ max(sum(fracV), 1e-8);
      else
         % Fractions are simply based on counts
         fracV = double(countV) ./ double(sum(countV));
      end
      
      validateattributes(countV, {'uint64'}, {'finite', 'nonnan', 'size', size(dS.valueV)})
      checkLH.prob_check(fracV, 1e-8);
   end
   
   
   %% Formatted frequency table
   %{
   OUT
      cell array
   
   Currently assumes that values are integer
   %}
   function tbM = formatted_freq_table(dS, inV, wtV)
      [countV, fracV] = dS.freq_table(inV, wtV);
      nv = length(countV);
      tbM = cell([nv+1, 4]);
      
      ir = 1;
      tbM(ir,:) = {'Value',  'Label', 'Count', 'Fraction'};
      
      for i1 = 1 : nv
         ir = ir + 1;
         if isempty(dS.valueLabelV)
            labelStr = ' ';
         else
            labelStr = dS.valueLabelV{i1};
         end
         tbM(ir,:) = {sprintf('%.0f', dS.valueV(i1)),  labelStr,  sprintf('%i', countV(i1)),  sprintf('%.1f', 100 .* fracV(i1))};
      end
   end
end
   
end
