function project_start(suffixStr, restoreState)
% Startup for a project
%{
Local or remote computer

Dealing with shared code:
It must be possible to have a project specific location for shared code.
Before putting shared code on path, check whether it's already there

To make code self-contained
1. copy all dependencies to a common dir
2. edit base directories for all projects used
3. edit base directory for shared code

%}

if nargin < 2
   restoreState = false;
end



%% Which computer are we on?
% Determines only the base dir

compS = configLH.Computer([]);
   webSiteDir = fullfile(compS.docuDir, 'data/web/hendri54.github.io');



%% List of projects

switch suffixStr
   %% With Todd
   case 'bc3'
      baseDir = fullfile(compS.dropBoxDir, 'hc', 'borrow_constraints', 'model3', 'prog');
      cd(baseDir);
      init_bc3;    
   case 'icps'
      % Will typically be called from 'mmp' (and therefore not put shared dirs on path)
      progDir = fullfile(compS.docuDir, 'econ', 'Migration', 'nis_wage_gains', 'cps', 'github', 'prog');
      %cd(progDir);
      %init_icps;
      standard_startup(suffixStr, progDir);
   case 'mmp'
      % Self contained (has its own copy of `shared` code)
      baseDir = fullfile(compS.docuDir, 'econ', 'Migration', 'nis_wage_gains', 'mmp', 'github', 'prog');
      cd(baseDir);
      init_mmp;
      
      
   %% Single authored
   case 'so1'
      % Accounting for experience profiles (BE Journal 2017)
      progDir = fullfile(compS.dropBoxDir, 'hc', 'school_ojt', 'experience', 'model2', 'prog');
      cd(progDir);
      init_so1;
      
      
   %% Data projects      
   case 'cps'
      progDir = fullfile(compS.docuDir, 'econ', 'data', 'Cps', 'prog');
      standard_startup(suffixStr, progDir);
   case 'cpsearn'
      progDir = fullfile(compS.docuDir, 'econ', 'data', 'Cps', 'earn_profiles', 'progs');
      standard_startup(suffixStr, progDir);      
   case 'pu'
      progDir = fullfile(compS.docuDir, 'econ', 'data', 'MicAnalyst', 'prog2017');
      standard_startup(suffixStr, progDir);
      
      
   %% Classes      
   case '520'
      % Standard startup
      progDir = fullfile(webSiteDir, 'econ520');
      standard_startup(suffixStr, progDir);
   case '720'
      % Standard startup
      progDir = fullfile(webSiteDir, 'econ720');
      standard_startup(suffixStr, progDir);
   case 'honors'
      progDir = fullfile(webSiteDir, 'honors');
      standard_startup(suffixStr, progDir);
   case 'hon'
      progDir = fullfile(compS.dropBoxDir, 'classes', 'honors', 'code');
      standard_startup(suffixStr, progDir);
      
      
   %% From github
   % Simply adds the dir to the path (if not on it already)
   case 'export_fig'
      if isempty(which('export_fig'))
         progDir = fullfile(compS.repoDir, 'export_fig');
         addpath(progDir);
      end
      
   otherwise
      error('Invalid');
      %start_from_file(suffixStr, restoreState);
end

end


% %% Load from file
% function start_from_file(suffixStr, restoreState)
%    pS = project_load(suffixStr);
% 
%    if ~isempty(pS)
%       pS.startup;
%       if restoreState
%          pS.restore_state;
%       end
%    else
%       warning('Project not found');
%    end
% end


%% Is shared directory already on path?
function onPath = shared_dir_on_path
   % Store current dir
   currDir = pwd;
   % Switch to home dir (so that we are not in shared right now)
   cd('~');
   % Try to find a file in shared
   onPath = ~isempty(which('const_lh'));
   % Restore previous dir
   cd(currDir);
end


%% Standard project. 
%{
Puts the "usual" shared dirs on the path (unless they already are)
%}
function standard_startup(suffixStr, progDir)
   disp(['Startup ', suffixStr]);

   % Prog dir on path
   assert(exist(progDir, 'dir') > 0,  'Prog dir does not exist');
   addpath(progDir);
   
   % Shared dirs, unless they are already on path
   % sharedDir1 = fileparts(which('const_lh'));
   if ~shared_dir_on_path
      compS = configLH.Computer([]);
      for i1 = 1 : length(compS.sharedDirV)
         addpath(compS.sharedDirV{i1});
      end
   end
   
   cd(progDir);
   
   if exist(fullfile(progDir, ['init_', suffixStr, '.m']), 'file')
      eval(['init_', suffixStr]);
   else
      disp(['No init file for project [',  suffixStr,  ']']);
   end
end