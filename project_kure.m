function project_kure(suffixStr, inputV)
% Run a project on Kure
%{
Simply runs startup to put everything on path
Then passes inputV to a prog named 'run_batch_xx'
'run_batch' must accept inputs as cell array

inputV
   single numbers can be numeric, but vectors must be string because of the way the command is
   submitted by the job scheduler
%}

project_start(suffixStr);

mFileStr = ['run_batch_', suffixStr];

if nargin < 2
   inputV = [];
end

% fprintf('Running m file %s with input arguments \n',  mFileStr);
% if ~isempty(inputV) 
%    for i1 = 1 : length(inputV)
%       disp(inputV{i1});
%    end
% else
%    disp('  no input arguments');
% end

if isempty(inputV)
   eval(mFileStr);
else
   eval([mFileStr, '(inputV);']);
end


end