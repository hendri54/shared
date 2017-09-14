% Code to read variables from PWT
%{
Given: xlsx file with original data
Once and for all: make into a table

Variables are made lower case
%}
classdef PennWorldTable < handle
      
properties
   % Version number
   verNum  double
   % Same as string (e.g. 81 for 8.1)
   verStr  char
   
   % PWT directory
   pwtDir  char
   % Dir with data files
   dataDir  char
   % Dir with `mat` files
   matDir  char
   
   % Data file (xlsx)
   dataFile  char
   
   % Meta info
   % Year range in data
   year1  double
   year2  double

   % Variable names
   vnCountry = 'countrycode';
   vnYear = 'year';
   vnPop = 'pop';
   vnXRate = 'xrat';
   vnCurrency = 'currency_unit';
end

properties (Constant)
   matFile = 'data_table';
   
end


methods
   %% Constructor
   function pS = PennWorldTable(verNum)
      pS.verNum = verNum;
      pS.verStr = sprintf('pwt%.0f', 10 * pS.verNum);
      
      compS = configLH.Computer([]);
      
      pS.pwtDir = fullfile(compS.docuDir, 'econ', 'data', 'Pwt', pS.verStr);
      pS.dataDir = fullfile(pS.pwtDir, 'data');
      pS.matDir  = fullfile(pS.pwtDir, 'mat');
      pS.dataFile = fullfile(pS.dataDir, [pS.verStr, '.xlsx']);
      
      % Version specific
      switch pS.verNum
         case 7.1
            pS.year1 = 1950;
            pS.year2 = 2010;
            % pS.vnPop = 'POP';
         case 8.1
            pS.year1 = 1950;
            pS.year2 = 2011;
         case 9
            pS.year1 = 1950;
            pS.year2 = 2014;
            pS.vnXRate = 'xr';
         otherwise
            error('Not implemented');
      end
      
      pS.validate;
   end
   
   
   function validate(pS)
      validateattributes(pS.verNum, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'scalar', '>', 5, ...
         '<=', 9})
      assert(exist(pS.pwtDir, 'dir') > 0,  [pS.pwtDir, '  does not exist']);
   end
   
   
   %% Make table from xlsx
   %{
   Needs to be done only once
   %}
   function make_table(pS, overWrite)
      if nargin < 2
         error('Missing input argument');
      end
      filesLH.mkdir(pS.matDir);
      if ~overWrite
         fn = pS.var_fn(pS.matFile);
         if exist(fn, 'file')
            return;
         end
      end
      % Read xls
      m = readtable(pS.dataFile);
      
      % Rename `isocode` to `countrycode`
      idx1 = find(strcmp('isocode', m.Properties.VariableNames));
      if ~isempty(idx1)
         disp('Renaming isocode');
         m.Properties.VariableNames{idx1} = pS.vnCountry;
      end
      
      % Make variable names lower case
      m.Properties.VariableNames = lower(m.Properties.VariableNames);
      
      % Save as mat
      pS.var_save(m, pS.matFile);
   end
   
   
   %% Load data table
   function m = load_table(pS)
      m = pS.var_load(pS.matFile);
   end
   
   
   %% List all country codes
   function wbCodeV = country_list(pS)
      m = pS.var_load(pS.matFile);
      wbCodeV = unique(m.(pS.vnCountry));
   end
   
   
   %% Variable saving / loading
   function fn = var_fn(pS, varName)
      fn = fullfile(pS.matDir, [varName, '.mat']);
   end
   
   function var_save(pS, saveS, varName)
      save(pS.var_fn(varName),  'saveS');
      disp(['Saved variable  ',  varName]);
   end
   
   function loadS = var_load(pS, varName)
      loadS = load(pS.var_fn(varName));
      loadS = loadS.saveS;
   end
   
   
   %% Load a variable for one country / all years
   function outV = load_var_country(pS, varName, wbCode)
      m = pS.load_table;
      idxV = find(strcmp(m.countrycode, wbCode));
      assert(~isempty(idxV),  'Country not found');
      assert(isequal(m.year(idxV),  (pS.year1 : pS.year2)'));
      outV = m.(lower(varName))(idxV);
   end
   
   
   %% Find countries
   %{
   Start indices
   %}
   function [startIdxV, endIdxV] = find_countries(pS, wbCodeV)
      m = pS.load_table;
      countryV = m.(pS.vnCountry);
      clear m;
      
      startIdxV = nan(size(wbCodeV));
      endIdxV = nan(size(wbCodeV));
      for ic = 1 : length(wbCodeV)
         idxV = find(strcmp(wbCodeV{ic}, countryV));
         if ~isempty(idxV)
            startIdxV(ic) = idxV(1);
            endIdxV(ic) = idxV(end);
         end
      end
   end
   
   
%    %% Find years
%    function yIdxV = find_years(pS, yearV)
%       m = pS.load_table;
%       yIdxV = nan(size(yearV));
%       for i1 = 1 : length(yearV)
%          idx1 = find(m.(pS.vnYear) == yearV(i1), 1, 'first');
%          if ~isempty(idx1)
%             yIdxV(i1) = idx1;
%          end
%       end
%    end
   
   
   %% Load a variable by country / year
   function outM = load_var_yc(pS, varName, wbCodeV, yearV)
      % Make sure all years are valid
      assert(all(ismember(yearV, pS.year1 : pS.year2)));
      % For a given country: year indices requested
      yrIdxV = yearV - pS.year1;
      % Country rows in table
      [startIdxV, endIdxV] = pS.find_countries(wbCodeV);
      
      m = pS.load_table;
      mDataV = m.(lower(varName));
      
      nc = length(wbCodeV);
      ny = length(yearV);
      outM = nan([ny, nc]);

      % Loop over valid countries
      for ic = find(startIdxV(:)' > 0)
         outM(:, ic) = mDataV(startIdxV(ic) + yrIdxV);
      end      
   end
end
   
end
