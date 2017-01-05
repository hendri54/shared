% Destination for FTP uploads
%{
Assumes that it is mounted as a volume

Because one would like to see output of rsync: allow option to write rsync commands to a file. +++

DO NOT USE. REPLACED BY KureLH +++++
%}
classdef FtpTarget < handle
   
properties
   % Mounted drive location
   mountedVolume  char  = '/Volumes/Macbook pro 2011/';
   % Remote base dir
   % remoteBaseDir = '/users/lutz/';
   testMode  logical  =  false;
end


methods
   %% Constructor
   % Provide name / value pairs as inputs
   function kS = FtpTarget(varargin)
      if ~isempty(varargin)
         for i1 = 1 : 2 : (length(varargin) - 1)
            kS.(varargin{i1}) = varargin{i1+1};
         end
      end
   end
   
   
   %% Is remote drive mounted?
   function isMounted = is_mounted(kS)
      isMounted = (exist(kS.mountedVolume, 'dir') > 0);
   end
   
   
   %% Upload shared code
   % Including startup files
   function upload_shared_code(kS)
      lhS = const_lh;
      % Remote and local file structure are exactly the same
      kS.updownload(lhS.localS.sharedBaseDir,  fullfile(kS.mountedVolume, lhS.localS.sharedBaseDir),  'up');
      kS.updownload(lhS.localS.iniFileDir, lhS.localS.iniFileDir, 'up');
   end
   
   
   %% Upload or download from remote
   %{
   Uses mounted volume (via rsync)
   User provides the full remote path

   If local dir does not exist: error
   If remote dir does not exist and if drive is mounted: create it if needed
   %}
   function updownload(kS, localDir, remoteDir, upDownStr)

      dbg = 111;

      % Input check
      if ~exist(localDir, 'dir')
         error('Local dir does not exist');
      end
      if ~(strcmp(upDownStr, 'up')  ||  strcmp(upDownStr, 'down'))
         error('Invalid upDownStr');
      end
      assert(kS.is_mounted);


      % Sync

      % baseDir = '/Volumes/killdevil/';
      if strcmp(upDownStr, 'up')
         sourceDir = localDir;
         tgDir = remoteDir;
         % When uploading: delete orphan files
         deleteStr = ' --delete ';
      else
         sourceDir = remoteDir;
         tgDir = localDir;
         % Do not delete orphans
         deleteStr = [];
      end

      % Must remove trailing '/' from tgDir
      if tgDir(end) == '/'
         tgDir(end) = [];
      end

      % But sourceDir must have trailing '/'
      if sourceDir(end) ~= '/'
         sourceDir = [sourceDir, '/'];
      end

      % Create remote dir if needed
      if ~exist(sourceDir, 'dir')
         filesLH.mkdir(sourceDir, dbg);
      end
      if ~exist(tgDir, 'dir')
         filesLH.mkdir(tgDir, dbg);
      end

      % Options
      %  -a: recursive directories
      %  -t: preserve file times
      %  -u: update; skip newer files
      %  -z: compress
      %  --delete: delete orphaned target files (only used when uploading)
      scriptStr = ['rsync -atuz ',  deleteStr, ' "',  sourceDir, '"  "',  tgDir,  '" '];

      disp(scriptStr)
      %keyboard;
      if ~kS.testMode
         % '&' runs asynchronously; omit the ';' at end to see output
         % rsync does not generate output in matlab
         [~, cmdOut] = system(scriptStr);
         %disp(cmdOut)
      end

      disp(['Done syncing  ',  sourceDir,  '  to  ',  tgDir]);
   end   
end
   
end