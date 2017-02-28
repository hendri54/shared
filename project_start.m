function project_start(suffixStr, restoreState)
% Startup for a project
%{
Only on local machine
%}

dropBoxDir = '/Users/lutz/Dropbox';

if nargin < 2
   restoreState = false;
end

switch suffixStr
   case 'bc3'
      baseDir = fullfile(dropBoxDir, 'hc', 'borrow_constraints', 'model3', 'prog');
      cd(baseDir);
      init_bc3;      
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