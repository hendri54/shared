%% Make command to upload or download from remote
%{
Uses mounted volume (via rsync)
OR
SSH login. Then remoteDir will be prefixed by 'lhendri@longleaf.unc.edu:' or similar

User provides the full remote path

If local dir does not exist: error
If remote dir does not exist and if drive is mounted: create it if needed

IN
   localDir  ::  char
   remoteDir  ::  char
      full path, starting from whatever is mounted as remote volume
      e.g. '/nas/longleaf/home/lhendri/Users'
      may be []. Then set to same as localDir on mounted volume
%}
function [scriptStr, sourceDir, tgDir] = updownload_command(kS, localDir, remoteDir, upDownStr)
   dbg = 111;   
   
   if isempty(remoteDir)
      remoteDir = kS.make_remote_dir(localDir);
%       if kS.is_mounted
%          % Default: same as local dir
%          remoteDir = fullfile(kS.mountedVolume, localDir);
%       else
%          % Now the url is 'lhendri@longleaf.unc.edu:/nas/longleaf/...'
%          remoteDir = [kS.clusterName, ':', fullfile(kS.remoteBaseDir, localDir)];
%       end
   end

   % Input check
   if ~exist(localDir, 'dir')
      error('Local dir does not exist \n  %s',  localDir);
   end
   if ~(strcmp(upDownStr, 'up')  ||  strcmp(upDownStr, 'down'))
      error('Invalid upDownStr');
   end


   % *******  Sync

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
   
   % Exclude hidden files and dirs
   excludeStr = ' --exclude ".*/" --exclude ".*" ';

   % Must remove trailing '/' from tgDir
   if tgDir(end) == '/'
      tgDir(end) = [];
   end

   % But sourceDir must have trailing '/'
   if sourceDir(end) ~= '/'
      sourceDir = [sourceDir, '/'];
   end

   % Create remote dir if needed
   if kS.is_mounted  &&  ~kS.testMode
      if ~exist(sourceDir, 'dir')
         filesLH.mkdir(sourceDir, dbg);
      end
      if ~exist(tgDir, 'dir')
         filesLH.mkdir(tgDir, dbg);
      end
   end
   
   % Options
   %  -a: recursive directories
   %  -t: preserve file times
   %  -u: update; skip newer files
   %  -v: verbose
   %  -z: compress
   %  --delete: delete orphaned target files (only used when uploading)
   scriptStr = ['rsync -atuzv ',  deleteStr, excludeStr, ' "',  sourceDir, '"  "',  tgDir,  '" '];

end   
