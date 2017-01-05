classdef FileNames < handle
   
properties
   % Cell array of file names
   nameListV  cell
end


methods
   %% Constructor
   function fS = FileNames(nameV)
      fS.nameListV = nameV;
   end
   
   %% Append current date
   function nameV = append_date(fS)
      dStr = datestr(now, 'YYYY_mm_dd');
      nameV = cell(size(fS.nameListV));
      for i1 = 1 : length(nameV)
         [fDir, fName, fExt] = fileparts(fS.nameListV{i1});
         newName = [fName, dStr, fExt];
         if isempty(fDir)
            nameV{i1} = newName;
         else
            nameV{i1} = fullfile(fDir, newName);
         end
      end
   end
end
   
end