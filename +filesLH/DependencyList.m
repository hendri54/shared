% Create list of dependencies for all m files in a list
%{
Extension: allow a list of folders in constructor

Purpose: make a list of all files used in a project, including shared code.
   This can then be backed up to a zip file
%}
classdef DependencyList < handle
   
properties
   % List of files (full paths) for which dependencies are to be found
   fileList  string
end


methods
   %% Constructor
   %{
   IN
      inList
         either a list of file names (complete paths) (string array)
         or a directory name
   %}
   function dl = DependencyList(inList)
      % Populate with initial list of files
      if ischar(inList)
         % Input is directory name
         assert(exist(inList, 'dir') > 0,   'Directory does not exist');
         
         % Get all files in directory and its sub-directories
         f = filesLH.Folder(inList);
         inList = f.get_all_files('*.m');
         
      else
         assert(isa(inList, 'string'), 'String array expected');
      end      
      
      dl.fileList = inList;
   end
   
   
   %% Make dependency list
   %{
%    IN
%       excludeSelf  ::  logical
%          exclude files in `inList` (which will usually be project program dir)
   OUT
      outV  ::  cell
         list of full paths of dependencies
         includes files in the folder(s) inList itself
   %}
   function outV = dependencies(dl)
      % Matlab bug: this sometimes changes case of directories
      outV = matlab.codetools.requiredFilesAndProducts(stringLH.string_array_to_cell(dl.fileList));
   end
   
   
   %% Copy files to a new dir
   %{
   Purpose: make code self-contained
   
   Copy all dependencies hang off a common srcDir (e.g. /Users/lutz/Documents/econ/matlab/shared)
   to a new tgDir
   Makes required directories
   
   IN
      listV  ::  cell
         output of dependencies (allows user to manipulate that output before copying)
         may be []
      overWrite  ::  logical
         overwrite existing files in tgDir?
      dryRun  ::  logical
         only show list of files to be copied
   %}
   function copy_dependencies(dl, listV, srcDir, tgDir, overWrite, dryRun)
      if isempty(listV)
         listV = dl.dependencies;
      end
      
      fprintf('\nCopying dependencies  (%i files)\n',  length(listV));
      fprintf('Source dir  %s \n', srcDir);
      fprintf('Target dir  %s \n', tgDir);
      assert(exist(srcDir, 'dir') > 0,  'Source dir does not exist');
      filesLH.mkdir(tgDir);

      % Loop over files
      sLen = length(srcDir);
      for i1 = 1 : length(listV)
         fPath = listV{i1};
         % Does file live in specified source dir?
         if strncmpi(fPath, srcDir, sLen)
            % New path replaces srcDir with tgDir
            fPathNew = fullfile(tgDir,  fPath((sLen+1) : end));
            % Check whether file already exists, unless overWrite = true
            if overWrite  ||  ~exist(fPathNew, 'file')
               if dryRun
                  fprintf('  %s   ->   %s \n',  fPath, fPathNew);
               else
                  outDir = fileparts(fPathNew);
                  filesLH.mkdir(outDir);
                  copyfile(fPath, fPathNew);
               end
            end
         end
      end
   end
   
   
   %% Back up to zip file
   %{
   IN
      zipFile :: char
         target zip file
      overWrite :: logical
         overwrite if zip file exists?
   %}
   function back_up_zip(dl,  zipFile,  overWrite)
      disp('Backing up to zip file');
      outV = dl.dependencies;
      fprintf('Number of files: %i \n',  numel(outV));
      filesLH.zip_files(zipFile,  outV,  overWrite);
      disp('Backup done.');
   end
   
end
   
   
end