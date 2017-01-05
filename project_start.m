function project_start(suffixStr, restoreState)
% Startup for a project

if nargin < 2
   restoreState = false;
end

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