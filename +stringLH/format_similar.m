function outStr = format_similar(inStr, inNumber, dbg)
% Format a number similarly to another (given as a formatted string)
%{
IN
   inStr
      formatted number as string
      may be exponential notation
   inNumber
      number to be formatted
%}

%% Input check
if dbg
   assert(isa(inStr, 'char'));
   assert(isa(inNumber, 'numeric'));
   assert(isequal(length(inNumber), 1));
end


if any(lower(inStr) == 'e')
   % Scientific notation
   eIdx = find(lower(inStr) == 'e');
   nDecimals = n_decimals(inStr(1 : (eIdx-1)));
   outStr = sprintf('%.*e', nDecimals, inNumber);
   
else
   % Decimal notation
   nDecimals = n_decimals(inStr);
   outStr = sprintf('%.*f', nDecimals, inNumber);
end


end


% Find no of decimal places in a number (not scientific notation)
function nDecimals = n_decimals(inStr)
   % No of decimals
   periodIdx = find(inStr == '.');
   if isempty(periodIdx)
      nDecimals = 0;
   else
      nDecimals = length(inStr) - periodIdx;
   end
end