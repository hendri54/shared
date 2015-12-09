classdef LatexTableLH < handle
%{
Other methods:
   write_table
      write to latex file
%}
   
properties
   filePath
   % Size, excluding headers
   nr
   nc
   
   % ***  Table contents
   
   % Body
   tbM
   colHeaderV
   rowHeaderV
   
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
end



methods
   %% Constructor
   %{
   Must provide table dimensions (nr, nc) (not counting headers)
   Other options are optional, as (name, value) pairs.
   If omitted, they are set to `default_values`
   %}
   function tS = LatexTableLH(nr, nc, varargin)
      tS.nr = nr;
      tS.nc = nc;
      tS.tbM = cell(nr, nc);
      defaultM = tS.default_values;
      tS = function_lh.input_parse(varargin, tS, defaultM(:,1), defaultM(:,2));
   end
   
   
   %% Default options
   function defaultM = default_values(tS)
      defaultM = cell(10, 2);
      ir = 0;
      
      ir = ir + 1;
      % Assume package siunitx is installed for alignment
      alignDefaultV = repmat({'S'},  [1, tS.nc]);
      defaultM(ir,:) = {'alignV',  alignDefaultV};
      ir = ir + 1;
      defaultM(ir, :) = {'alignHeader', 'r'};
      ir = ir + 1;
      defaultM(ir,:) = {'colHeaderV', string_lh.vector_to_string_array(1 : (tS.nc), 'Var%i')};
      ir = ir + 1;
      defaultM(ir,:) = {'rowHeaderV', string_lh.vector_to_string_array(1 : (tS.nr), 'Row%i')};
      ir = ir + 1;
      defaultM(ir,:) = {'colLineV', zeros(tS.nc, 1)};
      ir = ir + 1;
      defaultM(ir,:) = {'rowUnderlineV', zeros(tS.nr, 1)};
      ir = ir + 1;
      defaultM(ir,:) = {'colWidthV', zeros(tS.nc, 1)};
      ir = ir + 1;
      defaultM(ir,:) = {'lineStrV', cell(tS.nr, 1)};
%       ir = ir + 1;
%       defaultM(ir,:) = {};
      defaultM = defaultM(1 : ir, :);
   end
   
   
   %% Validate
   function validate(tS)
      validateattributes(tS.rowHeaderV(:), {'cell'}, {'size', [tS.nr, 1]})
      validateattributes(tS.colHeaderV(:), {'cell'}, {'size', [tS.nc, 1]})
   end
   
   % ir is a row number (not counting header)
   function validate_row(tS, ir)
      validateattributes(ir, {'double'}, {'finite', 'nonnan', 'nonempty', 'integer', '>=', 1, '<=', tS.nr})
   end
   
   function validate_col(tS, ic)
      validateattributes(ic, {'double'}, {'finite', 'nonnan', 'nonempty', 'integer', '>=', 1, '<=', tS.nc})
   end
   
   
%    %% Fill in headers
%    function fill_row_header(tS)
%       tS.tbM(2:end, 1) = tS.rowHeaderV;
%    end
%    
%    function fill_col_header(tS)
%       tS.tbM(1, 2:end) = tS.colHeaderV;
%    end
   
   
   %% Fill the table body
   % One can also set `tbM` in one go
   
   % Fill a single cell by position
   % ir, ic are row / variable numbers
   function fill(tS, ir, ic, valueStr)
      tS.validate_row(ir);
      tS.validate_col(ic);

      tS.tbM{ir, ic} = valueStr;
   end
   
   % Fill a table row
   function fill_row(tS, ir, valueV, fmtStr)
      tS.validate_row(ir);
      if isa(valueV, 'cell')
         tS.tbM(ir, :) = valueV;
      else
         % Vector of numbers
         tS.tbM(ir, :) = string_lh.vector_to_string_array(valueV, fmtStr);
      end
   end

   % Fill a table col
   function fill_col(tS, ic, valueV, fmtStr)
      tS.validate_col(ic);
      if isa(valueV, 'cell')
         tS.tbM(:, ic) = valueV;
      else
         % Vector of numbers
         tS.tbM(:, ic) = string_lh.vector_to_string_array(valueV, fmtStr);
      end
   end

   
   %% Find a cell by name
   function [ir, ic] = find(tS, rowHeader, colHeader)
      ir = tS.find_row(rowHeader);
      ic = tS.find_col(colHeader);
   end
   
   function ir = find_row(tS, rowHeader)
      ir = find(strcmp(tS.rowHeaderV, rowHeader));
%       if ~isempty(ir)
%          ir = ir + 1;
%       end
   end

   function ic = find_col(tS, colHeader)
      ic = find(strcmp(tS.colHeaderV, colHeader));
%       if ~isempty(ic)
%          ic = ic + 1;
%       end
   end

   
   %% Make complete table with headers (as cell array)
   function dataM = cell_table(tS)
      dataM = cell(tS.nr + 1, tS.nc + 1);
      dataM(2:end, 2:end) = tS.tbM;
      dataM(2:end, 1) = tS.rowHeaderV;
      % May have to wrap these in `{}` for `siunitx` package
      dataM(1, 2:end) = tS.colHeaderV;
   end
   
   
   %% Write text table that can be read "by hand"
   % Does not write contents of lineStrV
   function write_text_table(tS)
      dbg = 111;
      [fDir, fName, fExt] = fileparts(tS.filePath);
      textPath = fullfile(fDir, [fName, '.txt']);
      fp = fopen(textPath, 'w');
      
      cellLH.text_table(tS.cell_table, [1; tS.rowUnderlineV(:)], fp, dbg);
      
      fclose(fp);
      
      % Also show on screen
      cellLH.text_table(tS.cell_table, [1; tS.rowUnderlineV(:)], 1, dbg);

   end
   
end
      
end