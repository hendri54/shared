function out1 = contains(inStr, subStrV, dbg)
% Does string contain any of the provided sub-strings?
%{
IN
   inStr :: String
   subStrV
      either cell array of string  OR
      a single string (then we search individual characters from that string)
%}

out1 = false;

if isa(subStrV, 'char')
   for i1 = 1 : length(subStrV)
      if any(inStr == subStrV(i1))
         out1 = true;
         break
      end
   end
   
elseif isa(subStrV, 'cell')
   for i1 = 1 : length(subStrV)
      if ~isempty(strfind(inStr, subStrV{i1}))
         out1 = true;
         break
      end
   end
   
else
   error('Invalid');
end


end