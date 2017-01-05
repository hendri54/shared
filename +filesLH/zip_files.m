function zip_files(zipFile, fileListV, overWrite)
% Zip a bunch of files, given as full paths. Preserve directory structure in zip file
%{
Matlab `zip` preserves directory structure if files are relative paths in a common root dir
This function simply converts the full paths into relative paths and calls `zip`

If zip file exists, overWrite governs what happens
   true:    over write
   false:   do nothing
   any else:  ask

IN:
   zipFile :: char
      full or relative path of zip file to be created
   fileListV :: cell array
      full paths of all files to be saved
%}

assert(isa(zipFile, 'char'),  'Expecting a string input');
assert(isa(fileListV,  'cell'),  'Expecting cell array input');
if nargin < 3
   overWrite = [];
end

% Should we proceed (in case zip file exists)?
if exist(zipFile, 'file')
   if isempty(overWrite)
      doProceed = inputLH.ask_confirm(sprintf('Overwrite zip file  %s?',  zipFile), 'x');
   else
      doProceed = overWrite;
   end
else
   doProceed = true;
end

if doProceed
   % Make relative paths and root dir
   [relPathV, baseDir] = filesLH.make_relative_paths(fileListV);

   zip(zipFile, relPathV, baseDir);
else
   disp('Zip file exists.');
end

end