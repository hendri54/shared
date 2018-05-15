function outV = table_row(dataV)
% Take a cell or string array and make it into a table row
%{
Includes the terminal \\ (NOT escaped)
Can be written to file using fprintf('%s', outV)
but NOT fprintf(outV)
%}

if isa(dataV, 'string')
   dataV = cellstr(dataV);
end

nr = length(dataV);

% Write element 1
outV = dataV{1};

% Write other elements
if nr > 1
   for ir = 2 : nr
      outV = [outV, ' & ', dataV{ir}];
   end
end

% End of line character
outV = [outV, ' \\'];

end