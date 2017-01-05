classdef Folder < handle
   
properties
   path  char
end


methods
   %% Constructor
   function f = Folder(inPath)
      f.path = inPath;
   end
   
   
   %% Get all files in directory and its sub-directories
   %{
   IN
      patternStr
         pattern for `dir`, such as 'c*.m'
   OUT
      inList
         string array with paths of all files
   %}
   function fileListV = get_all_files(f,  patternStr)
      fListV = dir(fullfile(f.path, ['**', filesep, patternStr]));
      % Make a list of all those full paths
      fileListV = strings(length(fListV), 1);
      for i1 = 1 : length(fListV)
         fileListV(i1) = fullfile(fListV(i1).folder, fListV(i1).name);
      end
   end
end
   
   
end