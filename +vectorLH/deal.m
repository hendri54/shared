% Make a vector into separate scalars
%{
IN
   x  ::  vector
%}
function varargout = deal(x)
   for i1 = 1 : length(x)
      varargout{i1} = x(i1);
   end
end