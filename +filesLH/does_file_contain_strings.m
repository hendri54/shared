function foundV = does_file_contain_strings(filePath, findStrV, useRegEx)
% Does a file contain any of a set of given strings?
%{
IN
   findStrV :: string array
   useRegEx :: Bool
      interpret findStrV as regex?
      findStrV can contain (escaped or unescaped special characters: '\', '_')
%}

if ~exist(filePath, 'file')
   error('File does not exist');
end

% Read file into a single string
fileStr = fileread(filePath);

% Search a specific string and find all rows containing matches
foundV = zeros(size(findStrV));
for i1 = 1 : length(findStrV)
   if useRegEx
      findStr = stringLH.regex_escape(findStrV{i1});
      foundV(i1) = ~isempty(regexp(fileStr, findStr, 'once'));
   else
      foundV(i1) = ~isempty(strfind(fileStr, findStrV{i1}));
   end
end

end