% Convert a numeric vector into a cell array of strings
%{
IN
   stringOutput  ::  logical, optional
      return string output or cell array (default)
%}
function strV = vector_to_string_array(numberV, fmtStr)
   strV = cell(size(numberV));
   for i1 = 1 : length(numberV)
      strV{i1} = sprintf(fmtStr, numberV(i1));
   end
end