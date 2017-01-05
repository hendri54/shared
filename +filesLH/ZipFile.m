% Zip file routines
classdef ZipFile < handle
   
properties
   zipFileName  char
end

methods
   %% Constructor
   function zS = ZipFile(fn)
      zS.zipFileName = fn;
   end
   
   
   %% Add a list of files to an existing (or new) zip file
   %{
   Replaces existing files
   %}
   function add_files(zS, fnListV)
      if ischar(fnListV)
         fnListV = {fnListV};
      end
      
      for i1 = 1 : length(fnListV)
         cmdStr = sprintf('zip -u "%s" "%s"',  zS.zipFileName,  fnListV{i1});
         [~, cmdOut] = system(cmdStr);
         if ~isempty(cmdOut)
            disp(cmdOut);
         end
      end
   end
end
   
end