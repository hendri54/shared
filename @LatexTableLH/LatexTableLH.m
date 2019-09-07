% Latex Table class
%{
Assumes that the dimensions of the table are known when the table is allocated
   
Body is separate from header rows or columns
   
Other methods:
   write_table
      write to latex file

Note: `siunitx` package creates Lyx problems. Therefore omit alignment on decimal points

Change:
   add method that constructs table body from a `table`
   table without row headers

   handle string input for column and row headers

   more convenient way of setting header rows
%}
classdef LatexTableLH < handle
   
properties (SetAccess = private)
   % Size, excluding headers
   nr  uint8
   nc  uint8

   % No of header rows
   nHeaderRows  uint8
end
   
properties
   % Many of these properties should be SetAcess = private, but then they cannot be set using the
   % default setting method
   filePath  char
   
   % ***  Table contents
   
   % Body. Cell array of char
   tbM  cell
   % Heat values, if this option is enabled
   heatM  double
   
   % Column headers; may be a matrix; each row is a row of column headers
   colHeaderV  cell
   % Strings that go into top left cell
   % Multiple, if there are multiple header rows
   topLeftCellV  string = []   
   % Header rows as complete latex strings
   headerLineV  cell
   % Lines below each header line; mainly for \cLine statements
   headerSubLineV  cell
   
   rowHeaderV  cell
   
   % ***  Formatting info
   
   % Cell array. Alignment strings, such as 'c' or 'l'
   alignV
   % Alignment for header
   alignHeader
   % Which columns get line on LEFT? Length nc
   colLineV
   % Which rows are underlined? Length nr
   rowUnderlineV
   % Column widths
   colWidthV
   % Override the contents of tbM with complete lines
   lineStrV
   
   dbg  logical = true
end



methods
   %% Constructor
   %{
   Must provide table dimensions (nr, nc) (not counting headers)
   Other options are optional, as (name, value) pairs.
   If omitted, they are set to `default_values`
   %}
   function this = LatexTableLH(nr, nc, varargin)
      this.nr = nr;
      this.nc = nc;
      this.tbM = cell(nr, nc);
      this.heatM = nan(nr, nc);
      
      defaultM = this.default_values;
      % This modifies tS in place
      functionLH.input_parse(varargin, this, defaultM(:,1), defaultM(:,2));
      
      % Implied properties
      this.nHeaderRows = size(this.colHeaderV, 1);
      if isempty(this.topLeftCellV)
         this.topLeftCellV = strings([this.nHeaderRows, 1]);
      end
      
      this.validate;
   end
   
   
   %% Default options
   %{
   OUT
      defaultM  ::  cell
         Cell array with columns [name, value]
   %}
   function defaultM = default_values(tS)
      defaultM = cell(10, 2);
      ir = 0;
      
      ir = ir + 1;
      % Assume package siunitx is installed for alignment (when using S to align on decimal point)
      % But this cannot be default. Otherwise mixed text/number columns create errors.
      alignDefaultV = repmat({'l'},  [1, tS.nc]);
      % alignDefaultV{1} = 'l';
      defaultM(ir,:) = {'alignV',  alignDefaultV};
      ir = ir + 1;
      defaultM(ir, :) = {'alignHeader', 'l'};
      ir = ir + 1;
      defaultM(ir,:) = {'colHeaderV', stringLH.vector_to_string_array(1 : (tS.nc), 'Var%i')};
      ir = ir + 1;
      defaultM(ir,:) = {'rowHeaderV', stringLH.vector_to_string_array(1 : (tS.nr), 'Row%i')};
      ir = ir + 1;
      defaultM(ir,:) = {'colLineV', zeros(tS.nc, 1)};
      ir = ir + 1;
      defaultM(ir,:) = {'rowUnderlineV', zeros(tS.nr, 1)};
      ir = ir + 1;
      defaultM(ir,:) = {'colWidthV', zeros(tS.nc, 1)};
      ir = ir + 1;
      defaultM(ir,:) = {'lineStrV', cell(tS.nr, 1)};
      ir = ir + 1;
      defaultM(ir,:) = {'headerLineV', cell(10, 1)};
      ir = ir + 1;
      defaultM(ir,:) = {'headerSubLineV', cell(10, 1)};
      ir = ir + 1;
      defaultM(ir,:) = {'topLeftCellV', []};
      defaultM = defaultM(1 : ir, :);
   end
   
   
   %% Set header lines
   function set_header_lines(this, hdLineV, hdSubLineV)
      this.headerLineV = hdLineV;
      this.nHeaderRows = length(this.headerLineV);
      if nargin >= 3
         this.headerSubLineV = hdSubLineV;
      end
   end
   
   
   function set_top_left_cell(this, topLeftCellV)
      this.topLeftCellV = string(topLeftCellV);
      assert(length(this.topLeftCellV) == this.nHeaderRows);
   end
   
   
   %% Set heat table
   function set_heat_table(this, heatM)
      this.heatM = heatM;
      assert(isequal(size(heatM), [this.nr, this.nc]));
      if any(~isnan(heatM(:)))
         assert(min(heatM(:), [], 1, 'omitnan') >= 0);
         assert(max(heatM(:), [], 1, 'omitnan') <= 100);
      end
   end
   
   
   %% Validate
   function validate(tS)
      validateattributes(tS.rowHeaderV(:), {'cell'}, {'size', [tS.nr, 1]})
      validateattributes(tS.colHeaderV, {'cell'}, {'size', [tS.nHeaderRows, tS.nc]})
   end
   
   % ir is a row number (not counting header)
   function validate_row(tS, ir)
      validateattributes(ir, {'numeric'}, {'finite', 'nonnan', 'nonempty', 'integer', '>=', 1, '<=', tS.nr})
   end
   
   function validate_col(tS, ic)
      validateattributes(ic, {'numeric'}, {'finite', 'nonnan', 'nonempty', 'integer', '>=', 1, '<=', tS.nc})
   end
   
   
   
   %% Fill the table body
   % One can also set `tbM` in one go
   
   
   % Fill a single cell by position
   % ir, ic are row / variable numbers
   function fill(tS, ir, ic, valueStr)
      tS.validate_row(ir);
      tS.validate_col(ic);

      tS.tbM{ir, ic} = char(valueStr);
   end
   
   
   % Fill a table row
   function fill_row(tS, ir, valueV, fmtStr)
      tS.validate_row(ir);
      if isa(valueV, 'cell')
         tS.tbM(ir, :) = valueV;
      elseif isa(valueV, 'string')
         tS.tbM(ir, :) = cellstr(valueV);
      elseif isnumeric(valueV)
         % Vector of numbers
         tS.tbM(ir, :) = stringLH.vector_to_string_array(valueV, fmtStr);
      else
         error('Invalid type');
      end
   end

   % Fill a table col
   function fill_col(tS, ic, valueV, fmtStr)
      tS.validate_col(ic);
      if isa(valueV, 'cell')
         tS.tbM(:, ic) = valueV;
      elseif isa(valueV, 'string')
         tS.tbM(:, ic) = cellstr(valueV);
      elseif isnumeric(valueV)
         % Vector of numbers
         tS.tbM(:, ic) = stringLH.vector_to_string_array(valueV, fmtStr);
      else
         error('Invalid input type');
      end
   end
   
   
   %% Fill the entire table
   %{ 
   IN:
      tbInM
         either cell array of string  OR  string array
         numeric array
      fmtStr  ::  char
         format string for numeric input array
   %}
   function fill_body(this, tbInM, fmtStr)
      assert(isequal(size(tbInM), [this.nr, this.nc]), 'Wrong size');
      if isa(tbInM, 'cell')
         this.tbM = tbInM;
      elseif isa(tbInM, 'string')
         this.tbM = convertStringsToChars(tbInM);
      elseif isnumeric(tbInM)
         for ir = 1 : this.nr
            this.fill_row(ir, tbInM(ir,:), fmtStr);
         end
      else
         error('Invalid type');
      end
   end
   
   
   %% Find a cell by name
   function [ir, ic] = find(tS, rowHeader, colHeader)
      ir = tS.find_row(rowHeader);
      ic = tS.find_col(colHeader);
   end
   
   function ir = find_row(tS, rowHeader)
      ir = find(strcmp(tS.rowHeaderV, rowHeader));
   end

   function ic = find_col(tS, colHeader)
      ic = find(strcmp(tS.colHeaderV, colHeader));
   end
   
   
   %% Get an entry by index
   function out1 = get(this, ir, ic)
      out1 = this.tbM{ir, ic};
   end

   
   %% Make complete table with headers (as cell array)
   %{
   Ignores lineStrV
   %}
   function dataM = cell_table(this)
      dataM = cell(this.nr + this.nHeaderRows, this.nc + 1);
      
      rIdxV = double(this.nHeaderRows) + (1 : this.nr);
      dataM(rIdxV, 1) = this.rowHeaderV;
      dataM(rIdxV, 2:end) = this.tbM;
      
      % May have to wrap these in `{}` for `siunitx` package
      dataM(1 : this.nHeaderRows, 2:end) = this.colHeaderV;
      if ~isempty(this.topLeftCellV)
         dataM(1 : this.nHeaderRows, 1) = cellstr(this.topLeftCellV(:));
      end
   end
   
   
   %% Write text table that can be read "by hand"
   % Does not write contents of lineStrV
   function write_text_table(tS)
      hdLineV = zeros([tS.nHeaderRows, 1]);
      hdLineV(end) = 1;

      if ~isempty(tS.filePath)
         tS.make_directory;
         [fDir, fName] = fileparts(tS.filePath);
         textPath = fullfile(fDir, [fName, '.txt']);
         fp = fopen(textPath, 'w');
         assert(fp > 0,  'Could not open file');

         cellLH.text_table(tS.cell_table, [hdLineV(:); tS.rowUnderlineV(:)], fp, tS.dbg);

         fclose(fp);
      end
      
      % Also show on screen
      cellLH.text_table(tS.cell_table, [hdLineV(:); tS.rowUnderlineV(:)], 1, tS.dbg);
   end
   
   
   %% Make directory
   function make_directory(tS)
      fDir = fileparts(tS.filePath);
      filesLH.mkdir(fDir, tS.dbg);
   end
   
   
   %% Write alignment block
   function lineStr = align_block(this)
      lineStr = ['\begin{tabular}{',  this.alignHeader];

      % Body columns
      for ic = 1 : this.nc
         % Left column line
         if this.colLineV(ic) == 1
            lineStr = [lineStr, '|'];
         end
         if this.colWidthV(ic) > 0.001
            lineStr = [lineStr, sprintf('p{%3.2fin}', this.colWidthV(ic))];
         else
            lineStr = [lineStr, this.alignV{ic}];
         end
      end

      % Right end line
      if this.colLineV(end) == 1
         lineStr = [lineStr, '|'];
      end
      lineStr = [lineStr, '}'];
   end
end
      
end