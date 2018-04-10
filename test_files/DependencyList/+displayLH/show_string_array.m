function show_string_array(inV, charWidth, dbg)
% Display a cell array of strings
%{
Display entries until a fixed width is reached
%}

% % Spacer between entries
% spaceStr = '    ';
% sLen = length(spaceStr);

iCol = 0;
for i1 = 1 : length(inV)
   len1 = length(inV{i1});
   if len1 > 0
      % Do we need new line?
      if iCol > 0
         % Length of spacer
         sLen = 5 - rem(iCol,5);
         if sLen < 3
            sLen = sLen + 5;
         end
         
         if iCol + len1 + sLen > charWidth
            fprintf('\n');
            iCol = 0;
         else
            fprintf('%s', repmat(' ', [1, sLen]));
            iCol = iCol + sLen;
         end
      end
      fprintf(inV{i1});
      iCol = iCol + len1;
   end
end

fprintf('\n');

end