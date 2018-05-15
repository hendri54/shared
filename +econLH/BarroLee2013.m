% Barro-Lee 2013 dataset
%{
Keep in mind that lu + lp + ls + lh = 100
%}
classdef BarroLee2013  < handle
      
properties
   dbg  uint16 = 111
end

properties (Constant)
   % Available years
   yearV = 1950 : 5 : 2010;

   % Valid age lower bounds
   ageLbV = 15 : 5 : 75;

   % Permitted values of sex selector
   sexValueV = {'m', 'f', 'mf'};

   % No of school levels
   nSchool = 7;

   % Variables for fraction by schooling: 
   sFracVarV = {'lu',	'lp',	'lpc',	'ls',	'lsc',	'lh',	'lhc'};
end

properties (SetAccess = private)
   % Directories
   dataDir  char
end


methods
   %% Constructor
   function blS = BarroLee2013
      compS = configLH.Computer([]);
      baseDir = fullfile(compS.docuDir, 'econ', 'data', 'BarroLee', 'bl2013');
      % blS.progDir = fullfile(baseDir, 'prog');
      % Downloaded datafiles are here. XLS and mat formats
      blS.dataDir  = fullfile(baseDir, 'data2014');
   end

   
   %% Load matlab dataset
   %{
   IN
      sexStr  ::  char
         e.g., 'mf'
   OUT
      m  ::  table
   %}
   function m = load_data(blS, sexStr)
      dataFn = fullfile(blS.dataDir, ['BL2013_', sexStr, '_v2.0.mat']);
      if ~exist(dataFn, 'file')
         error('File does not exist');
      end
      m = load(dataFn);
      m = dataset2table(m.st_dataset);
      
      validateattributes(m.year, {'numeric'}, {'finite', 'nonnan', 'nonempty', 'integer', ...
         '>=', 1950})


      % Get variables
      % varNameV = get(m, 'VarNames');
   end
   
   
   %% Load one variable, by [year, country]
   % Arbitrary years and country codes are allowed
   %{
   IN:
      varNameStr
         variable name from BL. E.g. yr_sch
      sexStr
         'mf' or 'f'
      ageV
         length 2; age range to use
         upper bound open is 999
         e.g. [15, 999] for pop age 15+
   %}
   function loadM = load_yc(blS, varNameStr, sexStr, ageV, yearV, cCodesV)
      ny = length(yearV);
      nc = length(cCodesV);


      % ***** Input check

      if nargin ~= 6
         error('Invalid nargin');
      end
      validateattributes(yearV,   {'numeric'}, {'finite', 'nonnan', 'nonempty', 'integer', '>', 1900, '<', 2020})
      validateattributes(ageV(:), {'numeric'}, {'finite', 'nonnan', 'nonempty', 'integer', '>=', 15, '<=', 999, ...
         'size', [2,1]})

      m = blS.load_data(sexStr);

      % Find rows with the right ages
      ageRowV = find(m.agefrom == ageV(1)  &  m.ageto == ageV(2));
      if isempty(ageRowV)
         error('Invalid ages');
      end

      % Find variable
      dataV  = m.(varNameStr);
      dataV  = dataV(ageRowV);
      mYearV = m.year(ageRowV);
      % Get country codes
      mCCodeV = m.WBcode(ageRowV);


      % ***** Loop over countries

      % Output matrix
      loadM = nan([ny, nc]);
      for ic = 1 : nc
         % Rows for this country
         cRowV = find(strncmpi(mCCodeV, cCodesV{ic}, 3));
         % Loop over years
         for iy = 1 : ny
            yrRow = find(mYearV(cRowV) == yearV(iy));
            if length(yrRow) == 1
               yrRow = cRowV(yrRow);
               loadM(iy, ic) = dataV(yrRow);
            end
         end
      end
   end   
   
   
   %% Load matrix of school fractions by [school, year, country]
   %{
   Sums to 1 for each country. 7 levels.
   %}
   function frac_sycM = load_school_fractions(blS, sexStr, ageV, yearV, wbCodeV)
      ny = length(yearV);
      nc = length(wbCodeV);
      frac_sycM = nan([blS.nSchool, ny, nc]);

      % Load the individual variables
      % The fraction "complete" are already correct
      for i1 = 1 : blS.nSchool
         frac_sycM(i1, :,:) = blS.load_yc(blS.sFracVarV{i1}, sexStr, ageV, yearV, wbCodeV);
      end

      % Make into percentages
      frac_sycM = frac_sycM ./ 100;

      % Missing values
      frac_sycM(frac_sycM < 0) = NaN;

      % Fraction "some X": need to subtract fraction complete
      for iVar = [2 4 6]
         frac_sycM(iVar, :,:) = frac_sycM(iVar,:,:) - frac_sycM(iVar+1,:,:);
      end


      % ******  Output check

      vIdxV = find(~isnan(frac_sycM));
      validateattributes(frac_sycM(vIdxV), {'double'}, ...
         {'finite', 'nonnan', 'nonempty', 'real', '>=', -1e-6, '<', 1})

      frac_sycM(vIdxV) = max(0, frac_sycM(vIdxV));

      % Check that each entry contains valid probs that sum to 1
      for ic = 1 : nc
         for iy = 1 : ny
            if all(~isnan(frac_sycM(:, iy, ic)))
               checkLH.prob_check(frac_sycM(:, iy, ic), 5e-3);
               frac_sycM(:, iy, ic) = frac_sycM(:, iy, ic) ./ sum(frac_sycM(:, iy, ic));
            end
         end
      end
   end   
end

end