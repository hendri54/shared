function archive(fileNameV, archiveDir)
% Archive a list of files
%{
This means: copy the files to (sub)directory 'archiveDir'. Append current date to names.
If files exist: warning

IN
   fileNameV  ::  char or string
      can be full paths or just names (then use current dir as base)
   archiveDir
      full path or just name of sub dir to copy to (e.g. 'old')
%}


%% Input check

if isa(fileNameV, 'char')
   fileNameV = string(fileNameV);
end


%% Make new file paths

flS = filesLH.FileNames(fileNameV);
flS.append_date(true);

if archiveDir(1) == filesep
   % Absolute path
   error('Not implemented');
else
   % Relative path
   flS.append_dir(archiveDir, true);
end


%% Copy the files (without replacement)

for i1 = 1 : length(fileNameV)
   filesLH.copy(fileNameV(i1),  flS.nameListV(i1),  false);
end


end