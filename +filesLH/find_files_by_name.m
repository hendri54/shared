function outV = find_files_by_name(baseDir, fileMaskIn, inclSubDirs, findStrV, useRegEx)
% Find all files whose names contain one of a set of strings
%{
IN
   baseDir
      dir everythings hangs off
   fileMaskIn
      file mask such as 'c*.m'
   inclSubDirs
      include sub dirs?
   findStrV
      cell array of strings to be found
      or single string
      do not escape special characters
   useRegEx
      interpret findStrV as regex?

Notes: lightspeed `glob` does something similar
%}

if ~exist(baseDir, 'dir')
   error('baseDir does not exist');
end
if ~isa(inclSubDirs, 'logical')
   error('Must be Bool');
end
if ischar(findStrV)
   findStrV = {findStrV};
end
if ~isa(findStrV, 'cell')
   error('Invalid');
end


%% Use rdir to find all matching files

% *****  Make the file spec string for rdir

if inclSubDirs
   fileMask = ['**', filesep, fileMaskIn];
else
   fileMask = fileMaskIn;
end

fileSpecStr = fullfile(baseDir, fileMask);
% disp(['File mask:  ',  fileSpecStr]);

% Get a list of files
outV = rdir(fileSpecStr);
if isempty(outV)
   return;
end
% fprintf('Number of matching files: %i \n', length(outV));



%% Loop over files and check whether each contains one of the strings

keepV = zeros(size(outV));
for i1 = 1 : length(outV)
   % Mark whether any of the strings are found
   for iStr = 1 : length(findStrV)
      if useRegEx
         isFound = ~isempty(regexp(outV(i1).name, findStrV{iStr}, 'once'));
      else
         isFound = ~isempty(strfind(outV(i1).name, findStrV{iStr}));
      end
      if isFound
         keepV(i1) = 1;
      end
      if keepV(i1)
         break;
      end
   end
end

keepIdxV = find(keepV);
outV = outV(keepIdxV);


end