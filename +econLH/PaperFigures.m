% Maintain a list of figures / tables that need to be copied to a directory (to be included in a
% paper)
classdef PaperFigures < handle

   
properties (SetAccess = private)
   % Default directories for source and target files
   tgDefaultDir  char
   srcDefaultDir  char
   % List of objects
   fileListV  cell
   % No of objects stored
   n  uint16
   
   % Also copy underlying data tables with these extensions
   dataExtV = {'csv'};
end


methods
   %% Constructor
   function pS = PaperFigures(srcDefaultDir, tgDefaultDir, n)
      pS.srcDefaultDir = srcDefaultDir;
      pS.tgDefaultDir = tgDefaultDir;
      pS.fileListV = cell(n, 1);
      pS.n = 0;
   end

   
   %% Add a file
   %{
   IN
      srcPath
         full path of source file  OR
         just file name; then use srcDefaultDir
         can also be a path relative to `srcDefaultDir`
      tgPath
         full path of target file  OR
         just name; then use tgDefaultDir  OR
         []: then use srcPath name and tgDefaultDir
         can also be a path relative to `tgDefaultDir`
      tgSubDir
         if tgPath is just a file, this is interpreted as sub dir of tgDefaultDir
   %}
   function add(pS, srcPath, tgPath, tgSubDir)
      if nargin < 4
         tgSubDir = [];
      end
      if nargin < 3
         tgPath = [];
      end
      
      fileS.srcPath = pS.make_src_path(srcPath);
      fileS.tgPath  = pS.make_tg_path(srcPath, tgPath, tgSubDir);
      pS.n = pS.n + 1;
      pS.fileListV{pS.n} = fileS;
   end
   
   
   
   %% Make a complete source path, including extension
   function outPath = make_src_path(pS, srcPath)
      [fDir, fName, fExt] = fileparts(srcPath);
      if ~isempty(fDir)
         % Dir is provided, use it
         if fDir(1) == filesep
            % Absolute path: use it
            outPath = srcPath;
         else
            % Relative path: add to default
            outPath = fullfile(pS.srcDefaultDir, srcPath);
         end
      else
         % No dir provided: use default
         outPath = fullfile(pS.srcDefaultDir, [fName, fExt]);
      end
   end
   
   
   %% Make a complete target path
   function outPath = make_tg_path(pS, srcPath, tgPath, tgSubDir)
      if isempty(tgPath)
         % Use defaults. Same as providing src file name and no dir
         [fDir, fName, fExt] = fileparts(srcPath);
         if  ~isempty(fDir)  &&  (fDir(1) ~= filesep)
            % Relative path: keep it
            tgPath = srcPath;
         else
            % Absolute path: ignore it
            tgPath = [fName, fExt];
         end
      end
      
      [fDir, fName, fExt] = fileparts(tgPath);

      if ~isempty(fDir)
         if fDir(1) == filesep
            % Absolute path: use it
            outPath = tgPath;
         else
            % Relative path: add to default
            outPath = fullfile(pS.tgDefaultDir, tgPath);
         end
      else
         if isempty(tgSubDir)
            outPath = fullfile(pS.tgDefaultDir, [fName, fExt]);
         else
            outPath = fullfile(pS.tgDefaultDir, tgSubDir, [fName, fExt]);
         end
      end
      
%       outPath
%       keyboard
   end
   

   %% Copy files
   function copy(pS)
      dbg = 111;
      if pS.n < 1
         warning('Nothing to copy');
         return;
      end
      
      % Loop over files
      for i1 = 1 : pS.n
         srcPath = pS.fileListV{i1}.srcPath;
         tgPath  = pS.fileListV{i1}.tgPath;
         assert(~isequal(srcPath, tgPath),  'Source and target path are the same');
         
         if ~exist(srcPath, 'file')
            fprintf('Source file does not exist:  %s \n',  srcPath);
            
         else
            tgDir = fileparts(tgPath);
            if ~exist(tgDir, 'dir')
               filesLH.mkdir(tgDir, dbg);
            end

            copyfile(srcPath, tgPath);
            
            % Copy the underlying data table, if desired
            if ~isempty(pS.dataExtV)
               for ix = 1 : length(pS.dataExtV)
                  dataExt = pS.dataExtV{ix};
                  [sDir, sName] = fileparts(srcPath);
                  srcPath2 = fullfile(sDir, [sName, '.', dataExt]);
                  if exist(srcPath2, 'file') > 0
                     [tDir, tName] = fileparts(tgPath);
                     tgPath2 = fullfile(tDir, [tName, '.', dataExt]);
                     copyfile(srcPath2, tgPath2);
                  end
               end
            end
         end
      end
   end
   
end
   
end