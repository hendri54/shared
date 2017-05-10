classdef FileNames < handle
   
properties
   % String array of file names
   nameListV  string
end


methods
   %% Constructor
   function fS = FileNames(nameV)
      fS.nameListV = string(nameV);
   end
   
   
   %% Append current date
   %{
   Given 'dir1/name1.txt' this produces 'dir1/name1_2017_04_19.txt'
   
   IN
      updateInPlace  ::  logical
         update object's nameListV?
   %}
   function nameV = append_date(fS, updateInPlace)
      if nargin < 2
         updateInPlace = false;
      end
      
      dStr = ['_', datestr(now, 'YYYY_mm_dd')];
      nameV = strings(size(fS.nameListV));
      for i1 = 1 : length(nameV)
         [fDir, fName, fExt] = fileparts(fS.nameListV{i1});
         newName = [fName, dStr, fExt];
         if isempty(fDir)
            nameV(i1) = newName;
         else
            nameV(i1) = fullfile(fDir, newName);
         end
      end
      
      if updateInPlace
         fS.nameListV = nameV;
      end
   end
   
   
   %% Append directory
   %{
   Given 'dir1/name1.txt' this produces 'dir1/dir2/name1.txt'
   dir1 can be []

   IN
      updateInPlace  ::  logical
         update object's nameListV?
   %}
   function nameV = append_dir(fS, dirName, updateInPlace)
      if nargin < 3
         updateInPlace = false;
      end
      
      nameV = strings(size(fS.nameListV));
      for i1 = 1 : length(nameV)
         [fDir, fName, fExt] = fileparts(fS.nameListV{i1});
         if isempty(fDir)
            newDir = dirName;
         else
            newDir = fullfile(fDir, dirName);
         end
         nameV(i1) = fullfile(newDir, [fName, fExt]);
      end
      
      if updateInPlace
         fS.nameListV = nameV;
      end
   end
end
   
end