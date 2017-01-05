% Create list of dependencies for all m files in a list
%{
Extension: allow a list of folders in constructor

Purpose: make a list of all files used in a project, including shared code.
   This can then be backed up to a zip file
%}
classdef DependencyList < handle
   
properties
   % List of files
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
   function outV = dependencies(dl)
      % Matlab bug: this sometimes changes case of directories
      outV = matlab.codetools.requiredFilesAndProducts(stringLH.string_array_to_cell(dl.fileList));
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