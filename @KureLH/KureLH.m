% KureLH
%{
Routines for using remote computational cluster
Assumes that remote volume is mounted as drive (using FUSE)
Then the remote paths are the same as the local paths, except for the /Volumes/longleaf part
%}
classdef KureLH < handle
   
properties 
   % Mounted drive location
   mountedVolume  char
   % Remote base dir (when mounted, this is base)
   remoteBaseDir  char
   % User name for ssh
   userName  char  =  'lhendri';
   % Cluster name, such as 'longleaf.unc.edu'
   clusterName  char
   % Job submission method ('lsf', 'sbatch')
   jobSubmitMethod  char
   % Number of days to run at most
   nDays = 3
   % Only show commands, but don't run them
   testMode  logical  =  false;   
end

properties (Dependent)
   % Special characters may have to be escaped
   % Depends on the jobSubmitMethod
   quoteStr  char
   lBracketStr  char
   rBracketStr  char
   lBraceStr  char
   rBraceStr  char
end


methods
   %% Constructor
   % Defaults to Longleaf
   function kS = KureLH(clusterName, varargin)
      if nargin < 1
         % Default cluster
         clusterName = 'longleaf';
      end
      assert(isa(clusterName, 'char'));
      clusterName = lower(clusterName);
      
      switch clusterName
         case 'longleaf'
            % Mounted drive location
            kS.mountedVolume = '/Volumes/Longleaf/';
            % Remote base dir
            kS.remoteBaseDir = '/nas/longleaf/home/lhendri/';
            kS.clusterName = 'longleaf.unc.edu';
            kS.jobSubmitMethod = 'sbatch';
         case 'killdevil'
            % Mounted drive location
            kS.mountedVolume = '/Volumes/killdevil/';
            % Remote base dir
            kS.remoteBaseDir = '/nas02/home/l/h/lhendri/';
            kS.clusterName = 'killdevil.unc.edu';
            kS.jobSubmitMethod = 'lsf';
         otherwise
            error('Invalid');
      end
      
      % Additional arguments
      % Can override defaults as well
      if ~isempty(varargin)
         for i1 = 1 : 2 : (length(varargin) - 1)
            kS.(varargin{i1}) = varargin{i1+1};
         end
      end
   end
   
   
   %% Dependent
   function q = get.quoteStr(kS)
      switch kS.jobSubmitMethod
         case 'lsf'
            q = '''';
         case 'sbatch'
            q = '\''';
         otherwise
            error('Invalid')
      end
   end
   
   function q = get.lBracketStr(kS)
      switch kS.jobSubmitMethod
         case 'lsf'
            q = '(';
         case 'sbatch'
            q = '\(';
         otherwise
            error('Invalid')
      end
   end

   function q = get.rBracketStr(kS)
      switch kS.jobSubmitMethod
         case 'lsf'
            q = ')';
         case 'sbatch'
            q = '\)';
         otherwise
            error('Invalid')
      end
   end

   function q = get.lBraceStr(kS)
      switch kS.jobSubmitMethod
         case 'lsf'
            q = '{';
         case 'sbatch'
            q = '\{';
         otherwise
            error('Invalid')
      end
   end
   
   function q = get.rBraceStr(kS)
      switch kS.jobSubmitMethod
         case 'lsf'
            q = '}';
         case 'sbatch'
            q = '\}';
         otherwise
            error('Invalid')
      end
   end
   
   %% Is remote drive mounted?
   function isMounted = is_mounted(kS)
      isMounted = (exist(kS.mountedVolume, 'dir') > 0);
   end
   
   
   %% Make remote dir that matches a local dir
   % This is for uploading with rsync only. Assumes the local base dir is mounted as drive. Or ssh
   function remoteDir = make_remote_dir(kS, localDir)
      if kS.is_mounted
         % E.g. '/Volumes/longleaf/Users/lutz'
         remoteDir = fullfile(kS.mountedVolume, localDir);
      else
         % Now the url is 'lhendri@longleaf.unc.edu:/nas/longleaf/...'
         remoteDir = [kS.userName, '@', kS.clusterName, ':', fullfile(kS.remoteBaseDir, localDir)];
      end
   end
   
   
   %% Upload or download a dir
   %{
   Empty remote dir: assume directory structure is replicated on remote
   %}
   function updownload(kS, localDir, remoteDir, upDownStr)
      if isempty(remoteDir)
         remoteDir = kS.make_remote_dir(localDir);
      end
      % Make the rsync command
      [scriptStr, sourceDir, tgDir] = kS.updownload_command(localDir, remoteDir, upDownStr);
      
      disp(scriptStr)
      if ~kS.testMode
         % '&' runs asynchronously; omit the ';' at end to see output
         % rsync does not generate output in matlab
         [~, cmdOut] = system(scriptStr);
         disp(cmdOut)
      end

      disp(['Done syncing  ',  sourceDir,  '  to  ',  tgDir]);      
   end
   
   
   %% Upload shared code
   % Including startup files
   function upload_shared_code(kS)
      compS = configLH.Computer([]);
      % Just sync entire matlab code dir
      kS.updownload(compS.sharedBaseDir,  [],  'up');
%       for i1 = 1 : length(lhS.localS.sharedDirV)
%          kS.updownload(lhS.localS.sharedDirV{i1},  lhS.kureS.sharedDirV{i1},  'up');
%       end
%       kS.updownload(lhS.localS.iniFileDir, lhS.kureS.iniFileDir, 'up');
   end
   
   
   %% Copy a list of files to the server
   %{
   Uses ftp if needed, but cp if server is mounted
   
   IN
      remoteDir
         if []: use same a localDir, but on server
   %}
   function copy_files(kS, fileListV, localDir, remoteDir, upDownStr)      
      if kS.is_mounted
         cmdStr = 'cp ';
      else
         cmdStr = 'sftp ';
      end
      
      if isempty(remoteDir)
         remoteDir = kS.make_remote_dir(localDir);
      end
      if isa(fileListV, 'char')
         fileListV = {fileListV};
      end
      if strcmpi(upDownStr, 'down')
         % Flip local and remote dirs
         tmpDir = localDir;
         localDir = remoteDir;
         remoteDir = tmpDir;
      end
      
      for i1 = 1 : length(fileListV)
         remoteFile = fullfile(remoteDir, fileListV{i1});
         if ~kS.testMode
            fprintf('Copying from %s \n',  fullfile(localDir, fileListV{i1}));
            fprintf('        to   %s \n',  remoteFile);
            scriptStr = [cmdStr,  fullfile(localDir, fileListV{i1}),  ' ',  remoteFile];
            disp(scriptStr);
            [~, cmdOut] = system(scriptStr);
            disp(cmdOut)
         end         
      end
   end
   

   %% Construct the command to run on KURE
   %{
   Command format is
      command({a, b, c})
   IN
      suffixStr
         project suffix, e.g. 'so1'
         defined in project list
      argV
         cell array with arguments expected by `run_batch`
         can be []; then project_kure will be called with only one arg
      jobNameStr :: char
         job name, so it can be identified in list of running jobs
      logStr
         log file name, e.g. `set1.out`
      nCpus
         no of cpus (1 if not parallel)
   %}
   function cmdStr = command(kS, mFileName, argV, jobNameStr, logStr, nCpus, nDays)
      if ~isempty(nDays)
         kS.nDays = nDays;
      end
      
      % ******  Input check
      validateattributes(nCpus, {'numeric'}, {'finite', 'nonnan', 'nonempty', 'integer', 'scalar', ...
         '>=', 1, '<=', 16})
      validateattributes(kS.nDays, {'numeric'}, {'finite', 'nonnan', 'nonempty', 'integer', 'scalar', ...
         '>=', 1, '<=', 15})
      assert(isa(logStr, 'char'));
      
      argStr = kS.make_arg_string(argV);
      mFileStr = [mFileName, kS.lBracketStr, argStr,  kS.rBracketStr];

      switch kS.jobSubmitMethod
         case 'lsf'
            lS = linuxLH.LSF;
            cmdStr = lS.command(mFileStr, logStr, nCpus);
         case 'sbatch'
            lS = linuxLH.SBatch;
            cmdStr = lS.command(jobNameStr, mFileStr, logStr, nCpus, kS.nDays);
         otherwise
            error('Invalid');
      end
   end

   
   
   
   %% Make cell array of arguments into string of format ', {a, b, c}'
   function argStr = make_arg_string(kS, argV)
      if ~isempty(argV)
         assert(isa(argV, 'cell'));      

         % Make a string out of the cell array of arguments
         argStr = kS.lBraceStr;
         for i1 = 1 : length(argV)
            arg1 = argV{i1};
            if isa(arg1, 'char')
               % Enclose strings in quotes
               newStr = [kS.quoteStr, arg1, kS.quoteStr];
            elseif isnumeric(arg1)
               if isscalar(arg1)
                  % Scalar: just make into a string
                  newStr = num2str(arg1);
               elseif isvector(arg1)
                  % Vector: make into string '\[1 2 3\]'
                  newStr = '\[';
                  for i2 = 1 : length(arg1)
                     newStr = [newStr, ' ', num2str(arg1(i2))];
                  end
                  newStr = [newStr, '\]'];
               else
                  error('Not implemented');
               end
            else
               error('Not implemented');
            end
            argStr = [argStr, newStr];
            if i1 < length(argV)
               argStr = [argStr, ','];
            end
         end
         argStr = [argStr, kS.rBraceStr];
      else
         % '[]'
         % argStr = '\[\]';
         argStr = '';
      end
   end
      
end

   
end