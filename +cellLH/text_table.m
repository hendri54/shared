function text_table(dataM, rowUnderlineV, fp, dbg)
% Write a cell array of strings to a text table
%{
IN
   dataM  ::  cell
      The data to show. Text array
      [] is permitted and shown as ' '
   rowUnderlineV
      Underline this row?
   fp
      file pointer; if not present, use std io
%}

%% Input check

if isempty(fp)
   fp = 1;
end
assert(fp > 0,  'File pointer not valid');

[nRows, nCols] = size(dataM);
assert(isa(dataM, 'cell'),  'Expecting cell array input');

if length(rowUnderlineV) ~= nRows
   error('Invalid rowUnderlineV');
end


%% Find the width for each column

colWidthV = zeros(1, nCols);
lengthM = zeros(nRows, nCols);
for ic = 1 : nCols
   for ir = 1 : size(dataM, 1)
      lengthM(ir,ic) = length(dataM{ir,ic});
      colWidthV(ic) = max(colWidthV(ic), lengthM(ir,ic));
   end
end

% Total width of table
tbWidth = sum(colWidthV) + 2 .* nCols + 1;

underlineStr = repmat('-', [1, tbWidth]);


%% Write the table

fprintf(fp, '\n');
fprintf(fp, underlineStr);
fprintf(fp, '\n');
for ir = 1 : nRows
   % Make a string for this row
   strV = ' ';
   for ic = 1 : nCols
      nSpaces = colWidthV(ic) - lengthM(ir,ic) + 2;
      if isempty(dataM{ir, ic})
         dataStr = ' ';
      else
         dataStr = dataM{ir, ic};
      end
      assert(isa(dataStr, 'char'));
      strV = [strV, repmat(' ', [1, nSpaces]), dataM{ir,ic}];
   end
   % Format correctly for fprintf
   fprintf(fp, latexLH.str_escape(strV));
   fprintf(fp, '\n');

   if rowUnderlineV(ir) == 1  ||  ir == nRows
      fprintf(fp, underlineStr);
      fprintf(fp, '\n');
   end
end


end
