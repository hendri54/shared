function outV = table_row(dataV, heatV)
% Take a cell or string array and make it into a table row
%{
Includes the terminal \\ (NOT escaped)
Can be written to file using fprintf('%s', outV)
but NOT fprintf(outV)

IN
   heatV  ::  double, optional
      if present, cell colors will be written to generate a heatmap effect
%}

if nargin < 2
   heatV = nan(size(dataV));
end

if isa(dataV, 'string')
   dataV = cellstr(dataV);
end

nr = length(dataV);

% Write element 1
outV = value_string(dataV{1}, heatV(1));

% Write other elements
if nr > 1
   for ir = 2 : nr
      outV = [outV, ' & ', value_string(dataV{ir}, heatV(ir))];
   end
end

% End of line character
outV = [outV, ' \\'];

end


%% Make string for value
function dStr = value_string(valueStr, heatValue)
   if isnan(heatValue)
      dStr = valueStr;
   else
      dStr = sprintf('\\cellcolor{blue!%.0f}%s', heatValue, valueStr);
   end
end