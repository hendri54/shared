% Code to read variables from PWT
%{
Given: xlsx file with original data
Once and for all: make into a table
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
end

properties (Constant)
   matFile = 'data_table';
end


methods
   %% Constructor
   function pS = PennWorldTable(verNum)
      pS.verNum = verNum;
      pS.verStr = sprintf('pwt%.0f', 10 * pS.verNum);
      
      lhS = const_lh;
      pS.pwtDir = fullfile(lhS.dirS.baseDir, 'econ', 'data', 'Pwt', pS.verStr);
      pS.dataDir = fullfile(pS.pwtDir, 'data');
      pS.matDir  = fullfile(pS.pwtDir, 'mat');
      pS.dataFile = fullfile(pS.dataDir, [pS.verStr, '.xlsx']);
      
      % Version specific
      switch pS.verNum
         case 7.1
            pS.year1 = 1950;
            pS.year2 = 2010;
         case 8.1
            pS.year1 = 1950;
            pS.year2 = 2011;
         otherwise
            error('Not implemented');
      end
      
      pS.validate;
   end
   
   
   function validate(pS)
      validateattributes(pS.verNum, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'scalar', '>', 5, ...
         '<=', 8.1})
      assert(exist(pS.pwtDir, 'dir') > 0,  [pS.pwtDir, '  does not exist']);
   end
   
   
   %% Make table from xlsx
   %{
   Needs to be done only once
   %}
   function make_table(pS, overWrite)
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
         m.Properties.VariableNames{idx1} = 'countrycode';
      end
      
      % Save as mat
      pS.var_save(m, pS.matFile);
   end
   
   
   %% Load data table
   function m = load_table(pS)
      m = pS.var_load(pS.matFile);
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
      outV = m.(varName)(idxV);
   end
end
   
end
