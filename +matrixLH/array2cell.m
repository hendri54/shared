function outM = array2cell(dataM, fmtStr)
% Convert a numeric array (dataM) to a cell array of formatted strings
%{
IN:
   fmtStr
      format string for sprintf
%}
% ------------------------------------------

f1 = @(x) sprintf(fmtStr, x);
outM = cellfun(f1, num2cell(dataM), 'UniformOutput', false);

end