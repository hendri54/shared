function show(tS, fid)
% Show a text table on the screen or write to a file, given by handle fid
%{
dataM
 The data to show. Text array
tbS
   rowUnderlineV
      Underline this row?
   fp
      file pointer; if not present, use std io
%}

if nargin < 2
   fid = 1;
end
if isempty(fid)
   fid = 1;
end


%% Find the width for each column, excluding header

headWidth = 0;
for ir = 1 : tS.nr
   headWidth = max(headWidth, length(tS.rowHeaderV{ir}));
end

colWidthV = zeros(1, tS.nc);
lengthM = zeros(tS.nr, tS.nc);
for ic = 1 : tS.nc
   for ir = 1 : tS.nr
      lengthM(ir,ic) = length(tS.tbM{ir,ic});
      colWidthV(ic) = max([colWidthV(ic), lengthM(ir,ic), length(tS.colHeaderV{ic})]);
   end
end

% Total width of table
tbWidth = headWidth + sum(colWidthV) + 2 .* (tS.nc + 1) + 1;

underlineStr = repmat('-', [1, tbWidth]);


%% Show

% Top line
fprintf(fid, '\n');
fprintf(fid, underlineStr);
fprintf(fid, '\n');

% Header row
strV = row_string(' ', headWidth, tS.colHeaderV, colWidthV);
fprintf(fid, '%s \n', strV);
fprintf(fid, underlineStr);
fprintf(fid, '\n');

for ir = 1 : tS.nr
   strV = row_string(tS.rowHeaderV{ir}, headWidth, tS.tbM(ir,:), colWidthV);
%    % Make a string for this row
%    strV = ' ';
%    for ic = 1 : tS.nc
%       nSpaces = colWidthV(ic) - lengthM(ir,ic) + 2;
%       strV = [strV, repmat(' ', [1, nSpaces]), tS.tbM{ir,ic}];
%    end
%    % Format correctly for fprintf
%    fprintf(fid, latex_lh.str_escape(strV));
   fprintf(fid, '%s \n', strV);

   if tS.rowUnderlineV(ir)  ||  ir == tS.nr
      fprintf(fid, underlineStr);
      fprintf(fid, '\n');
   end
end


end



%% Make a string for 1 row
function strV = row_string(headStr, headWidth, rowStrV, colWidthV)
   nc = length(rowStrV);
   strV = headStr;
   strV = [strV, repmat(' ', [1, headWidth - length(headStr) + 2])];
   for ic = 1 : nc
      nSpaces = colWidthV(ic) - length(rowStrV{ic}) + 2;
      strV = [strV, repmat(' ', [1, nSpaces]), rowStrV{ic}];
   end
   % Format correctly for fprintf
   strV = latex_lh.str_escape(strV);
end