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
   projectDir = fullfile(compS.docuDir, 'projects');


%% List of projects

switch suffixStr
   %% With Todd
   case 'bc3'
      baseDir = fullfile(compS.dropBoxDir, 'hc', 'borrow_constraints', 'model3', 'prog');
      cd(baseDir);
      init_bc3;    
   case 'bc4'
      baseDir = fullfile(compS.docuDir, 'projects', 'p2017', 'borrow_constraints', ...
         'model4', 'github_bc4', 'prog');
      cd(baseDir);
      init_bc4;          
   case 'cc2006'
      % Caselli/Coleman 2006 AER code
      progDir = fullfile(compS.docuDir, 'projects', 'p2017', 'jones_cc', 'github_jcc', 'cc2006', 'prog');
      standard_startup(suffixStr, progDir);
   case 'cpsbc'
      % CPS data for borrowing constraints project (with Todd and Chris)
      progDir = fullfile(compS.dropBoxDir, 'hc', 'borrow_constraints', 'cps', 'progs');
      standard_startup(suffixStr, progDir);
%       addpath(progDir);
%       init_cpsbc;
   case 'icps'
      % Will typically be called from 'mmp' (and therefore not put shared dirs on path)
      progDir = fullfile(compS.docuDir, 'econ', 'Migration', 'nis_wage_gains', 'cps', 'github', 'prog');
      %cd(progDir);
      %init_icps;
      standard_startup(suffixStr, progDir);
   case 'khcomp'
      % Capital skill complementarity; part of jones_cc
      progDir = fullfile(compS.docuDir, 'projects', 'p2017', 'jones_cc', 'github_jcc', 'khcomp', 'prog');
      standard_startup(suffixStr, progDir);
   case 'mmp'
      % Self contained (has its own copy of `shared` code)      
      baseDir = fullfile(compS.docuDir, 'econ', 'Migration', 'nis_wage_gains', 'mmp', 'github', 'prog');
      cd(baseDir);
      init_mmp;
   case 'nisimp'
      % ***** NIS project. Solve model with imperfect substitution
      progDir = fullfile(compS.docuDir, 'projects', 'p2017', 'jones_cc', 'github_jcc', 'nisimp', 'prog');
      standard_startup(suffixStr, progDir);
      % Was previously used for QJE (with the location below)
      %baseDir = fullfile(compS.docuDir, 'econ', 'Migration', 'nis_wage_gains', 'imperfect_substitution', 'nisimp', 'prog');
      %cd(baseDir);
      %init_nisimp;
   case 'icp2011'
      % ICP 2011 data for NISIMP
      progDir = fullfile(projectDir, 'p2017', 'jones_cc', 'github_jcc', 'icp2011');
      standard_startup(suffixStr, progDir);
   case 'jcc'
      % Data code for Jones-CC project
      progDir = fullfile(projectDir, 'p2017', 'jones_cc', 'github_jcc', 'country_data');
      standard_startup(suffixStr, progDir);
      
   %% Single authored
   case 'cstrat'
      % College stratification in IPEDS data
      progDir = fullfile(compS.docuDir, 'projects', 'p2017', 'college_stratification', 'github', 'prog');
      standard_startup(suffixStr, progDir);
   case 'jones'
      % Jones: bounding role of H for income gaps
      progDir = fullfile(compS.projectDir(2015), 'jones', 'progs');
      standard_startup(suffixStr, progDir);    
   case 'mocc'
      % Immigration occupational downgrading in the census
      progDir = fullfile(compS.projectDir(2018), 'migrant_occupations', 'prog');
      standard_startup(suffixStr, progDir);    
   case 'ms'
      % Manuelli/Seshadri (2014 AER)
      progDir = fullfile(compS.docuDir, 'projects', 'p2016', 'ms2014', 'prog');
      standard_startup(suffixStr, progDir);
   case 'occ'
      % Occupations: heterogeneity in education within occupations
      progDir = fullfile(compS.docuDir, 'projects', 'p2017', 'occupations', 'github', 'prog');
      standard_startup(suffixStr, progDir);
   case 'so1'
      % Accounting for experience profiles (BE Journal 2017)
      progDir = fullfile(compS.dropBoxDir, 'hc', 'school_ojt', 'experience', 'model2', 'prog');
      cd(progDir);
      init_so1;
      
      
   %% Data projects      
   case 'bl2013'
      % Barro Lee 2013
      progDir = fullfile(compS.docuDir, 'econ', 'data', 'BarroLee', 'bl2013', 'prog');
      standard_startup(suffixStr, progDir);
   
   case 'cps'
      progDir = fullfile(compS.docuDir, 'econ', 'data', 'Cps', 'prog');
      standard_startup(suffixStr, progDir);
   case 'cpsearn'
      progDir = fullfile(compS.docuDir, 'econ', 'data', 'Cps', 'earn_profiles', 'progs');
      standard_startup(suffixStr, progDir);      
   case 'ipumsi'
      progDir = fullfile(compS.docuDir, 'econ', 'data', 'ipumsi', 'prog');
      standard_startup(suffixStr, progDir);            
   case 'pu'
      progDir = fullfile(compS.docuDir, 'econ', 'data', 'MicAnalyst', 'prog2017');
      standard_startup(suffixStr, progDir);
   case 'sat'
      % SAT/ACT routines
      progDir = fullfile(compS.docuDir, 'projects', 'p2017', 'sat_act', 'prog');
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
%    case 'honors'
%       progDir = fullfile(webSiteDir, 'honors');
%       standard_startup(suffixStr, progDir);
   case 'hon'
      % Code for honors class Econ691H
      % Must be self-contained
      progDir = fullfile(compS.dropBoxDir, 'classes', 'honors', 'code');
      cd(progDir);
      init_hon;
      %standard_startup(suffixStr, progDir);
      
      
   %% Other
   case 'rail'
      progDir = fullfile(compS.dropBoxDir, 'shared', 'light_rail', 'ridership');
      standard_startup(suffixStr, progDir);
   case 'shared'
      standard_startup(suffixStr, compS.sharedDirV{1});
      
   %% From github
   % Simply adds the dir to the path (if not on it already)
   case 'export_fig'
      if isempty(which('export_fig'))
         progDir = fullfile(compS.repoDir, 'export_fig');
         addpath(progDir);
      end
      
   case 'nlopt'
      % NLOPT requires additional startup using optim_lh.nloptinit
      progDir = fullfile(compS.sharedBaseDir, 'nlopt', 'nlopt-2.4.2', 'octave');
      addpath(progDir);
      optimLH.nlopt_initialize('local');
      
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
   x = which('const_lh');
   % If not found, `which` returns 'Not on path' message
   % But sometimes [] is returned (why?)
   onPath = ~strncmpi(x, 'not', 3)  &&  ~isempty(x);
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
   assert(exist(progDir, 'dir') > 0,  'Prog dir does not exist:\n  %s', progDir);
   addpath(progDir);
   
   % Shared dirs, unless they are already on path
   % sharedDir1 = fileparts(which('const_lh'));
   if ~shared_dir_on_path
      disp('Adding shared dirs to path');
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