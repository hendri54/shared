% Info about computers code is supposed to run on
%{
Assumes that all computers only differ in a single base dir, such as '/Users/lutz'
%}
classdef Computer < handle

properties
   compName  char = []
   % Base directory that everything hangs off
   % Local: user home dir. Remote: prepend .../lhendri/
   baseDir  char = []
   % Are we on the local machine?
   runLocal  logical
   
   % For remote computers
   % Name of mounted volume (if using FUSE)
   mountedVolume  char
   
   % directories
   docuDir  char
   dropBoxDir  char
   sharedBaseDir  char  % 'econ/matlab'
      repoDir  char     %     'github'
      sharedDirV  cell  %     'shared'
         testFileDir  char
         testFileDir2  char
         tempDir  char
   
end


properties (Constant)
   % List of possible base directories and computer names
   nameV  =  {'local', 'longleaf'};
   baseDirV = {'/Users/lutz',  '/nas/longleaf/home/lhendri/'};
   mountedVolV = {'',  '/Volumes/killdevil/'};
end


methods
   %% Constructor
   %{
   IN
      compName
         one of nameV or [] (then determine the computer we are on)
   %}
   function cS = Computer(compName)
      cIdx = -1;
      
      if isempty(compName)
         % Determine what we are on
         for i1 = 1 : length(cS.baseDirV)
            if exist(cS.baseDirV{i1}, 'dir') > 0
               cIdx = i1;
               break;
            end
         end
      else
         % Find base dir
         %cS.compName = compName;
         cIdx = find(strcmp(compName, cS.nameV));
         %assert(length(cIdx) == 1);
         %cS.baseDir = cS.baseDirV(cIdxV);
      end

      validateattributes(cIdx, {'double'}, {'finite', 'nonnan', 'nonempty', 'integer', 'positive', 'scalar'})
      
      cS.baseDir = cS.baseDirV{cIdx};
      cS.compName = cS.nameV{cIdx};
      cS.mountedVolume = cS.mountedVolV{cIdx};
      
      % Are we on the local machine?
      cS.runLocal = (cIdx == 1);
      
      % Fill in other directories
      cS.add_derived_dirs;
   end
   
   


% ****  Remote
% Info for modifying directories in cS.dirS

% % This is the only place where info about the linux cluster should appear
% cS.clusterName = 'longleaf';
% 
% switch cS.clusterName
%    case 'longleaf'
%       cS.mountedVolume = '/Volumes/longleaf/';
%       % Users/lutz hangs off that
%       cS.remoteBaseDir = '/nas/longleaf/home/lhendri/';
%       %userDir = fullfile(cS.remoteBaseDir, 'Users', 'lutz');
%       %cS.kureS = add_derived_dirs(userDir, fullfile(userDir, 'Documents'));
%    case 'killdevil'
%       cS.mountedVolume = '/Volumes/killdevil/';
%       cS.remoteBaseDir = '/nas02/home/l/h/lhendri/';
%       %userDir = fullfile(cS.remoteBaseDir, 'Users', 'lutz');
%       %cS.kureS = add_derived_dirs(userDir, fullfile(userDir, 'Documents'));
%    otherwise
%       error('Invalid');
% end
% 



   %% Add derived dirs
   %{ 
   Assumes that remote dir structure is the same as local
   %}
   function add_derived_dirs(cS)
      cS.dropBoxDir = fullfile(cS.baseDir, 'Dropbox');

      cS.docuDir = fullfile(cS.baseDir, 'Documents');      
         % All general purpose matlab code hangs off this dir
         cS.sharedBaseDir = fullfile(cS.docuDir, 'econ', 'Matlab');
            % Startup files
            % dirS.iniFileDir = fullfile(dirS.sharedBaseDir, 'ini_files');
            % For github repos from other users
            cS.repoDir = fullfile(cS.sharedBaseDir, 'github');

            % Shared progs
            shareDir = fullfile(cS.sharedBaseDir, 'shared');
            cS.sharedDirV = {shareDir};

               % Test files go here
               cS.testFileDir  = fullfile(shareDir, 'test_files');
               cS.testFileDir2 = fullfile(shareDir, 'test_files2');

               % Temporary files go here
               cS.tempDir = fullfile(cS.sharedBaseDir, 'temp');

   end

   
   %% Project dir for a given year
   function outDir = projectDir(cS, year1)
      validateattributes(year1, {'numeric'}, {'integer', 'scalar', '>', 2000})
      outDir = fullfile(cS.docuDir, 'projects', sprintf('p%i', year1));
   end
end

end