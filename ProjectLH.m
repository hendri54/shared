% Project class
%{
Contains all info for starting a project
Info will be saved to a file

Directories are relative to 
- on local machine: root
- on remote machine: user root (.../lhendri)
      Users/lutz hang off this

Cannot use any shared code (except what is in startup dir)

Change:
   check that all paths are fully qualified, not relative, not starting with '~'
%}
classdef ProjectLH < handle
   
properties
   % Project name
   nameStr  char
   % Suffix for all prog files
   %  such as 'bc1'
   suffixStr  char
   % File for editor state
   stateFileStr  char
   
   % Base directory -- everything hangs off these
   %      all files typically hang off that dir
   %      this does NOT include the mounted volume info
   baseDir  char
   progDir  char
   % Shared dirs that need to be put on path
   sharedDirV  cell
   % Name of m file to run upon startup
   %  This runs in the namespace of the startup function. It cannot put things into the main
   %  namespace.
   initFileName  char
end

% properties (Constant)
%    % Column indices for local / remote
%    cLocal = 1;
%    cRemote = 2;
% end

methods
   %% Constructor
   %{
   IN
      sharedDirV
         directories for shared code that must be on path
      initFileName
         if [], construct
   %}
   function pS = ProjectLH(nameStr, baseDir, progDir, sharedDirV, suffixStr, initFileName)
%       lhS = const_lh;
      
      pS.nameStr = nameStr;
      pS.baseDir = baseDir;
      pS.progDir = progDir;
      
      if suffixStr(1) == '_'
         suffixStr(1) = [];
      end
      pS.suffixStr = suffixStr;
      
      if isempty(initFileName)
         pS.initFileName = ['init_', suffixStr];
      else
         pS.initFileName = initFileName;
      end
      
%      if isempty(sharedDirV)
%         pS.sharedDirV = lhS.dirS.sharedDirV;
%          ns = length(lhS.dirS.sharedDirV);
%          pS.sharedDirV = cell(ns, 2);
%          for ir = 1 : ns
%             pS.sharedDirM{ir,pS.cLocal} = lhS.localS.sharedDirV{ir};
%             pS.sharedDirM{ir,pS.cRemote} = lhS.kureS.sharedDirV{ir};
%          end
%      else
         pS.sharedDirV = sharedDirV;      
%      end
      
%       n = max(1, size(pS.sharedDirM, 1));
%       validateattributes(pS.sharedDirM, {'cell'}, {'size', [n, 2]})
      
      % File for editor state
      pS.stateFileStr = filesLH.fullpaths(fullfile(pS.progDir, 'editor_state.mat'));
   end
   
   
%    %% Are we running local or remote?
%    % Redundant. const_lh does that
%    function [ic, runLocal] = run_local(pS)
%       if exist('/Users/lutz', 'dir') > 0
%          runLocal = true;
%          ic = pS.cLocal;
%       else
%          runLocal = false;
%          ic = pS.cRemote;
%       end
%    end
   
   
   %% Put all required dirs on path
   % If running remotely, modify paths to include remote base dir
   function add_path(pS)
%       ic = pS.run_local;
%       lhS = const_lh;
%       % Figure out directory modifier for remote, if we are remote
%       if lhS.runLocal
%          dirPrefix = '';
%       else
%          dirPrefix = lhS.remoteBaseDir;
%       end
      addpath(filesLH.fullpaths(pS.progDir));
%       addpath(fullfile(dirPrefix, pS.progDir));
      n = length(pS.sharedDirV);
      if n > 0
         for ir = 1 : n
            addpath(filesLH.fullpaths(pS.sharedDirV{ir}));
         end
      end
   end
   
   
   %% Restore editor state from saved file
   function restore_state(pS)
      % Does not work on server. There is no editor
      lhS = const_lh;
      if lhS.runLocal
         meS = configLH.MatlabEditor;
         % For remote
         stateFileName = filesLH.fullpaths(pS.stateFileStr);
         assert(~isempty(stateFileName),  'No state file specified');
         assert(exist(stateFileName, 'file') > 0,  'File does not exist');
         meS.restore_state(stateFileName);
      end
   end
   
   
   %% Run startup for this project
   function startup(pS)
      disp(['Startup:  ',  pS.nameStr]);
      
      % Add all files to path
      pS.add_path;
      
      % CD to prog dir
%      ic = pS.run_local;
      cd(filesLH.fullpaths(pS.progDir));
      
      % Run init file
      initFile = pS.initFileName;
      if exist([initFile, '.m'], 'file') > 0
         eval(initFile);
      else
         disp('Init file does not exist');
         disp(initFile);
      end
   end
end
   
end