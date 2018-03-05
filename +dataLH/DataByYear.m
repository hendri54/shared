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
      validateattributes(yearV, {'numeric'}, {'finite', 'nonnan', 'nonempty', 'integer', '>', 1500, ...
         '<', 2100})
      if ischar(varNameV)
         varNameV = {varNameV};
      end
      
      % Unique years
      yearValueV = unique(yearV(yearV > 0));
      assert(~isempty(yearValueV));
      % Indices for unique years; may be NaN for years out of range
      yrIdxV = dS.year_range(yearValueV);
      
      % Find variables
      varIdxV = dS.var_columns(varNameV);
      if any(isnan(varIdxV))
         error('Variables not found');
      end
      
      % Extract data
      % The loop ensures reasonable speed when there are many repeated years
      outM = nan(length(yearV), length(varNameV));
      % Loop over years in data table (that have nonNan yrIdxV)
      for iy = find(yrIdxV(:)' > 0)
         rIdxV = find(yearV == yearValueV(iy));
         if ~isempty(rIdxV)
            outM(rIdxV, :) = repmat(dS.tbM{yrIdxV(iy), varIdxV}, [length(rIdxV), 1]);
         end
      end
   end
end
   
end