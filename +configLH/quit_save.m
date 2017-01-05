function quit_save(projectSuffix)
% Quit matlab after saving project state
%{
Restore state with `project_start`
%}

assert(nargin == 1);

% Retrieve project info
plS = ProjectListLH;
pS = plS.retrieve_suffix(projectSuffix);
assert(~isempty(pS));

% Save project state
meS = configLH.MatlabEditor;
assert(~isempty(pS.stateFileStr));
meS.save_state(pS.stateFileStr);

% Quit matlab
quit;


end