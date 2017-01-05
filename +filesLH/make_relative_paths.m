function [relPathV, baseDir] = make_relative_paths(fileListV)
% Given a list of absolute paths, return a common base dir and relative paths
%{
Useful for calling `zip` and preserving dir structure

IN:
   fileListV :: cell array
%}

% Find common base directory
baseDir = filesLH.common_base_directory(fileListV);

% No of characters to drop from start of each path
n = length(baseDir) + 1;
if baseDir(end) ~= filesep
   n = n + 1;
end

% Loop over files
relPathV = cell(size(fileListV));
for i1 = 1 : length(fileListV)
   filePath = fileListV{i1};   
   relPathV{i1} = filePath(n : end);   
end


end