function replace_text_many_files(baseDir, fileMaskIn, inclSubDirs, oldTextV, newTextV, excludeNameV, noConfirm)
% replace text in many files
%{
IN
   baseDir
      path everything hangs off
   fileMaskIn
      A wild card, such as 'c*.m'
   inclSubDir :: Bool
      include sub directories?
   excludeNameV
      list of file names (not with paths) to be excluded
      main purpose: exclude the prog calling this
   oldTextV, newTextV
      replacement table
      always interpreted as regex
%}

if nargin ~= 7
   error('Invalid nargin');
end
if ~exist(baseDir, 'dir')
   error('baseDir does not exist');
end
if ~isa(inclSubDirs, 'logical')
   error('Must be Bool');
end


%% Use rdir to find all matching files

useRegEx = true;
outV = filesLH.find_files_containing_strings(baseDir, fileMaskIn, inclSubDirs, oldTextV, useRegEx);

if isempty(outV)
   disp('No matching files');
   return;
end
fprintf('Number of matching files: %i \n', length(outV));

if ~inputLH.ask_confirm('Replace with this file mask?', noConfirm)
   return;
end


%%  Loop over files

for i1 = 1 : length(outV)
   % Is file excluded?
   exclude = false;
   if ~isempty(excludeNameV)
      [~, fileNameStr, fileExtStr] = fileparts(outV(i1).name);
      if any(strcmpi([fileNameStr, fileExtStr],  excludeNameV))
         exclude = true;
      end
   end
   if ~exclude
      filesLH.replace_text_in_file(outV(i1).name,  oldTextV, newTextV);
   end
end


end