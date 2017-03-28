function outStr = string_from_vector(xV, fmtStr)
% Given a vector, return a comma separated string
%{
Example
   xV = [2.4, 3.43]; fmtStr = '%4.2f'
   returns "2.40, 3.43"

Bug: for unknown reason, the result is not char
%}

if ~ischar(fmtStr)
   error('Invalid fmtStr');
end

n = length(xV);
if n == 1
   % Scalar input
   outStr = sprintf(fmtStr, xV);
   
else
   % Vector input
   outStr = sprintf(fmtStr, xV(1));
   for i1 = 2 : n
      outStr = [outStr, ', ', sprintf(fmtStr, xV(i1))];
   end

   outStr = char(outStr);
end


end