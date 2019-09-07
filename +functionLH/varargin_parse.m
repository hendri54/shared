function varargin_parse(x, inputV)
% Parse inputs provided as (name / value) pairs
%{
Call as 
   `varargin_parse(objS, varargin(:))`
IN
   x
      handle object that gets modified
   inputV
      cell array of name / value pairs
      can be varargin
%}

if ~isempty(inputV)
   for i1 = 1 : 2 : (length(inputV) - 1)
      x.(inputV{i1}) = inputV{i1+1};
   end
end


end