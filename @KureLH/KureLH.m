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
   % This is for uploading with rsync only. Assumes the local base dir is mounted as drive
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
   function updownload(kS, localDir, remoteDir, upDownStr)
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
      lhS = const_lh;
      % Just sync entire matlab code dir
      kS.updownload(lhS.dirS.sharedBaseDir,  [],  'up');
%       for i1 = 1 : length(lhS.localS.sharedDirV)
%          kS.updownload(lhS.localS.sharedDirV{i1},  lhS.kureS.sharedDirV{i1},  'up');
%       end
%       kS.updownload(lhS.localS.iniFileDir, lhS.kureS.iniFileDir, 'up');
   end
   
   
   %% Copy a list of files to the server
   %{
   IN
      remoteDir
         if []: use same a localDir, but on server
   %}
   function copy_files(kS, fileListV, localDir, remoteDir, upDownStr)
      assert(kS.is_mounted);
      
      if isempty(remoteDir)
         % This needs volume attached, but not the path to /Users/lutz
         remoteDir = fullfile(kS.mountedVolume, localDir);
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
            scriptStr = ['cp ',  fullfile(localDir, fileListV{i1}),  ' ',  remoteFile];
            [~, cmdOut] = system(scriptStr);
            %disp(cmdOut)
         end         
      end
   end
   

   %% Construct the command to run on KURE
   %{
   Command format is
      project_kure_XX(arguments)
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
   function cmdStr = command(kS, suffixStr, argV, jobNameStr, logStr, nCpus)
      % ******  Input check
      validateattributes(nCpus, {'numeric'}, {'finite', 'nonnan', 'nonempty', 'integer', 'scalar', ...
         '>=', 1, '<=', 16})
      assert(isa(logStr, 'char'));
      
      if ~isempty(argV)
         % Make string of format ', {a, b, c}'
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
         argStr = [',', argStr, kS.rBraceStr];
      else
         % '[]'
         % argStr = '\[\]';
         argStr = '';
      end
      
      mFileStr = ['project_kure', kS.lBracketStr, kS.quoteStr, suffixStr, kS.quoteStr,  argStr,  kS.rBracketStr];

      switch kS.jobSubmitMethod
         case 'lsf'
            lS = linuxLH.LSF;
            cmdStr = lS.command(mFileStr, logStr, nCpus);
         case 'sbatch'
            lS = linuxLH.SBatch;
            cmdStr = lS.command(jobNameStr, mFileStr, logStr, nCpus);
         otherwise
            error('Invalid');
      end
   end
      
end

   
end