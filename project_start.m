function project_start(suffixStr, restoreState)
% Startup for a project
%{
Only on local machine
%}

dropBoxDir = '/Users/lutz/Dropbox';
docuDir    = '/Users/lutz/Documents';
webSiteDir = fullfile(docuDir, 'data/web/hendri54.github.io');

if nargin < 2
   restoreState = false;
end

switch suffixStr
   case 'bc3'
      baseDir = fullfile(dropBoxDir, 'hc', 'borrow_constraints', 'model3', 'prog');
      cd(baseDir);
      init_bc3;    
   case 'mmp'
      baseDir = fullfile(docuDir, 'econ', 'Migration', 'nis_wage_gains', 'mmp', 'prog');
      cd(baseDir);
      init_mmp;
   case '520'
      % Standard startup
      progDir = fullfile(webSiteDir, 'econ520');
      standard_startup(suffixStr, progDir);
   case '720'
      % Standard startup
      progDir = fullfile(webSiteDir, 'econ720');
      standard_startup(suffixStr, progDir);
   otherwise
      start_from_file(suffixStr, restoreState);
end

end

%% Load from file
function start_from_file(suffixStr, restoreState)
   pS = project_load(suffixStr);

   if ~isempty(pS)
      pS.startup;
      if restoreState
         pS.restore_state;
      end
   else
      warning('Project not found');
   end
end


%% Standard project. Runs only locally.
%{
Puts the "usual" shared dirs on the path
%}
function standard_startup(suffixStr, progDir)
   lhS = const_lh;
   disp(['Startup ', suffixStr]);
   
   assert(exist(progDir, 'dir') > 0,  'Prog dir does not exist');
   addpath(progDir);
   cd(progDir);
   
   for i1 = 1 : length(lhS.dirS.sharedDirV)
      addpath(lhS.dirS.sharedDirV{i1});
   end
   if exist(fullfile(progDir, ['init_', suffixStr, '.m']), 'file')
      eval(['init_', suffixStr]);
   else
      disp('No init file');
   end
end