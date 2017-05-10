% Data table with year and values
%{
Expect each variable to be a vector
%}
classdef DataByYear < handle
   
properties
   % Data table
   tbM
   
   dbg  uint16 = 111
end


methods
   %% Constructor: Provide a table
   function dS = DataByYear(tbM)
      dS.tbM = tbM;
      
      % Find the year column
      yrIdx = find(strcmpi(dS.tbM.Properties.VariableNames, 'year'));
      if length(yrIdx) == 1
         % Make a known name
         dS.tbM.Properties.VariableNames{yrIdx} = 'year';
      else
         error('Cannot find year column');
      end
   end
   
   
   %% Find rows for range of years
   function yrIdxV = year_range(dS, yearV)
      yrIdxV = nan(size(yearV));
      for iy = 1 : length(yearV)
         yrIdx = find(yearV(iy) == dS.tbM.year);
         if ~isempty(yrIdx)
            yrIdxV(iy) = yrIdx;
         end
      end
   end
   
   
   %% Find columns for variables
   function varIdxV = var_columns(dS, varNameV)
      if ischar(varNameV)
         varNameV = {varNameV};
      end
      varIdxV = nan(size(varNameV));
      for i1 = 1 : length(varNameV)
         varIdx = find(strcmp(dS.tbM.Properties.VariableNames,  varNameV{i1}));
         if length(varIdx) == 1
            varIdxV(i1) = varIdx;
         end
      end
   end
   
   
   %% Retrieve a subset of variables for a range of years
   %{
   Invalid variables: error
   Invalid years: NaN
   %}
   function outM = retrieve(dS, varNameV, yearV)
      validateattributes(yearV, {'double'}, {'finite', 'nonnan', 'nonempty', 'integer', '>', 1500, ...
         '<', 2100})
      if ischar(varNameV)
         varNameV = {varNameV};
      end
      % Find years and variables
      yrIdxV = dS.year_range(yearV);
      varIdxV = dS.var_columns(varNameV);
      if any(isnan(varIdxV))
         error('Variables not found');
      end
      
      % Extract data
      outM = nan(length(yrIdxV), length(varNameV));
      vIdxV = find(~isnan(yrIdxV));
      if ~isempty(vIdxV)
         outM(vIdxV, :) = dS.tbM{yrIdxV(vIdxV), varIdxV};
      end
   end
end
   
end