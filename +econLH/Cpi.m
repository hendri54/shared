% Consumer price index
%{
Load from text file. Then just query for the right years

It would be more efficient to store a DataByYearLH object instead of a table
%}

classdef Cpi < handle
   properties (SetAccess = private)
      % Table with fields year, CPI
      dataM
   end
   
   methods
      %% Constructor
      %{
      IN
         baseYear  ::  integer
            cpi base year
         cpiFn
            path with data file (columns Year, CPI)
      %}
      function cpiS = Cpi(baseYear, cpiFn)
         % Load file with [year, cpi]
         loadM = readtable(cpiFn);

         validateattributes(loadM.Year, {'double'}, {'finite', 'nonnan', 'nonempty', 'integer', '>', 1900, ...
            '<', 2020})
         validateattributes(loadM.CPI, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive'})

         % Convert so that base year has cpi of 1
         baseIdx = find(loadM.Year == baseYear);
         if length(baseIdx) ~= 1
            error('Invalid');
         end
         loadM.CPI = loadM.CPI ./ loadM.CPI(baseIdx);
         cpiS.dataM = loadM;
      end
      
      
      %% Retrieve for a set of years
      %{
      If year is out of bounds: NaN
      %}
      function outV = retrieve(cpiS, yearV)
         % Just use generic data by year code
         dS = dataLH.DataByYear(cpiS.dataM);
         outV = dS.retrieve('CPI', yearV);

         % there may be Nans
         validateattributes(outV, {'double'}, {'nonempty', 'real', 'positive', ...
            'size', [length(yearV), 1]})
      end

   end

end