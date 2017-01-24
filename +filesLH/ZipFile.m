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
   
   
   %% Add files to zip file; append dates to file names
   %{
   fnListV  ::  cell array of string
      relative paths of the files to be added
   baseDir  ::  char
      base dir for all files in fnListV
   tempDir  ::  char
      full dir for temporary files
   
   Change: store relative paths instead of absolute ones +++
   %}
   function add_files_with_dates(zS, fnListV, baseDir, tempDir)
      % Add current date to files
      fListS = filesLH.FileNames(fnListV);
      dateListV = fListS.append_date;

      % Copy file to temp dir with date attached
      zipListV = cell(size(fnListV));
      for i1 = 1 : length(fnListV)
         zipListV{i1} = fullfile(tempDir, dateListV{i1});
         fDir = fileparts(zipListV{i1});
         filesLH.mkdir(fDir, cS.dbg);
         copyfile(fullfile(baseDir, fnListV{i1}),  zipListV{i1});
      end

      % Add to zip file
      zS.add_files(zipListV);
   end
end
   
end