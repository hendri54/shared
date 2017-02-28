function xStr = regex_escape(inStr)
% Escape characters for correct regex string handling
%{
Replaces single '\' with '\\'
Replaces single '_' with '\_'
%}

xStr = inStr;

% Replace '_' (but not '\_') with '\_'
xStr = regexprep(xStr, '([^\\]+)(\_)', '$1\\_');

% Replace stuff\stuff with stuff\\stuff
xStr = regexprep(xStr, '([a-z0-9]+)\\([a-z0-9])+', '$1\\\\$2');

% Leading \
if xStr(1) == '\'  &&  xStr(2) ~= '\'
   xStr = ['\', xStr];
end

% Make sure we have no more single backslashes or '_'
idxV = strfind(xStr, '_');
if ~isempty(idxV)
   assert(all(xStr(idxV - 1) == '\'));
end

idxV = strfind(xStr, '\');
if ~isempty(idxV)
   for i1 = idxV(:)'
      valid = 0;
      if i1 > 1
         if xStr(i1 - 1) == '\'
            valid = 1;
         end
      end
      if i1 < length(xStr)
         if xStr(i1+1) == '\'  ||  xStr(i1+1) == '_'
            valid = 1;
         end
      end
      if ~valid
         error(['Invalid string:  ',  xStr]);
      end
   end
end

% % In case we already escaped: replace '\\\\' with '\\'
% 
% % Replace '_' with '\_'
% xStr = strrep(xStr,'_','\_');
% 
% % Now replace single '\' with double '\\' 
% xStr = strrep(xStr, '\','\\');
% 
% 
% % Replace '\\_'
% xStr = strrep(xStr, '\\_', '\_');


end