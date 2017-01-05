function baseDir = common_base_directory(fileListV)
% Find common base directory for a list of absolute paths
%{
IN
   fileListV :: cell array
%}

% Start with first path
currentPath = fileparts(fileListV{1});


% Loop over files
for i1 = 1 : numel(fileListV)
   filePath = fileListV{i1};

   % must be absolute path
   assert(isequal(filePath(1), filesep),  'Not an absolute dir');

   % Find common dir
   done = false;
   while ~done
      % Is this on the current path?
      %  Avoid case sensitivity because of bug in matlab code that generates dependency list.
      if strncmpi(currentPath,  filePath,  length(currentPath))
         done = true;
      else
         % Try the parent dir
         currentPath = fileparts(currentPath);
         
         if length(currentPath) < 2
            fprintf('Current path:  %s \n',  currentPath);
            fprintf('Current file:  %s \n',  filePath);
            keyboard;   % +++++
            error('Did not converge');
         end
      end
   end
end

baseDir = currentPath;

end