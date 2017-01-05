function updownload(kS, localDir, remoteDir, upDownStr)
% Upload or download from KURE
%{
Uses mounted volume if it exists (via rsync)
User provides the full remote path (as in /nas02/home/...)
The routine replaces the '/nas02/...' part with /Volumes/killdevil

If local dir does not exist: error
If remote dir does not exist and if drive is mounted: create it if needed
%}

dbg = 111;


%% Input check

if ~exist(localDir, 'dir')
   error('Local dir does not exist');
end
if ~(strcmp(upDownStr, 'up')  ||  strcmp(upDownStr, 'down'))
   error('Invalid upDownStr');
end


%% Sync

if kS.is_mounted
% baseDir = '/Volumes/killdevil/';
% if exist(baseDir, 'dir')
   % *****  Use rsync
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
   
   % Replace the base path with the mounted drive
   oldBase = kS.remoteBaseDir;      % '/nas02/home/l/h/lhendri/';
   sourceDir = strrep(sourceDir, oldBase, kS.mountedVolume);
   tgDir = strrep(tgDir, oldBase, kS.mountedVolume);
   
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
   system([scriptStr, '  &']);
   
   disp(['Done syncing  ',  sourceDir,  '  to  ',  tgDir]);
   
   
else
   % *****  Use Transmit
   scriptNameStr = 'osascript  /Users/lutz/Dropbox/data/software/scripts/kure_upload.scpt';

   scriptStr = [scriptNameStr, '  "',  localDir, '"  "',  remoteDir, '"  ',  upDownStr];

   % The & implies that caller does not wait for completion
   system([scriptStr, '  &']);
end

end