function outV = find_files_containing_strings(baseDir, fileMaskIn, inclSubDirs, findStrV, useRegEx, matchAll)
% Find all files that contain one of a set of strings
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
      do not escape special characters
   useRegEx
      interpret findStrV as regex?
   matchAll :: Bool
      keep files that match all or just one of the strings searched?

Change: could use lightspeed `glob` instead of rdir
%}

if ~exist(baseDir, 'dir')
   error('baseDir does not exist');
end
if ~isa(inclSubDirs, 'logical')
   error('Must be Bool');
end
if ~isa(findStrV, 'cell')
   error('Invalid');
end
if nargin < 6
   matchAll = false;
end


%% Use rdir to find all matching files

% *****  Make the file spec string for rdir

if inclSubDirs
   fileMask = ['**', filesep, fileMaskIn];
else
   fileMask = fileMaskIn;
end

fileSpecStr = fullfile(baseDir, fileMask);
disp(['File mask:  ',  fileSpecStr]);

% Get a list of files
outV = rdir(fileSpecStr);
if isempty(outV)
   return;
end
% fprintf('Number of matching files: %i \n', length(outV));



%% Loop over files and check whether each contains one of the strings

keepV = zeros(size(outV));
for i1 = 1 : length(outV)
   foundV = filesLH.does_file_contain_strings(outV(i1).name, findStrV, useRegEx);
   if matchAll
      keepV(i1) = all(foundV);
   else
      keepV(i1) = any(foundV);
   end
   
%    outV(i1).name
%    foundV
end

keepIdxV = find(keepV);
outV = outV(keepIdxV);


end