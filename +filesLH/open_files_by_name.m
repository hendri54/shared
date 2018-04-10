function open_files_by_name(baseDir, findStr)
% To quickly open a file without having to type the subdir
%{
Displays a list of matching files. Asks user to pick one.
If unique: file is directly opened

No unit testing b/c of user interaction

IN
   baseDir
      search this dir and sub-dirs
      if [], use pwd
   findStr
      part of the file name
%}


%% Input check
if isempty(baseDir)
   baseDir = pwd;
end
if ~exist(baseDir, 'dir')
   warning('baseDir does not exist');
   return
end
if ~ischar(findStr)
   error('String expected');
end


%% Find the files

useRegEx = false;
inclSubDirs = true;
fileMaskIn = '*.m';
outV = filesLH.find_files_by_name(baseDir, fileMaskIn, inclSubDirs, findStr, useRegEx);
nFound = length(outV);


%% Process results
if isempty(outV)
   disp('No matching files found');
   
   
elseif nFound == 1
   open(outV(1).name);
   
   
elseif nFound > 7
   fprintf('Found too many files (%i) \n', nFound);
   
   
else
   disp('Multiple matching files');
   for i1 = 1 : nFound
      [~, fNameStr, fExtStr] = fileparts(outV(i1).name);
      fprintf('  %i    %s%s \n',  i1,  fNameStr, fExtStr);      
   end
   fprintf('  %i    %s \n',  0,  'Open all');      
   
   % Pick a file to open
   ans1 = input('Pick a file to open  ');
   if ~isempty(ans1)  &&  isnumeric(ans1)
      if any(ans1 == (1 : nFound))
         open(outV(ans1).name);
      elseif ans1 == 0
         % Open all
         for i1 = 1 : nFound
            open(outV(i1).name);
         end
      end
   end
end


end