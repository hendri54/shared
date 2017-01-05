function dirOutV = fullpaths(dirInV, runLocal)
% Given a list of directories, return their full paths
%{
If local: 
   don't change anything
If remote: 
   prepend cluster base dir, unless the dir already contains it

Example:
   dirInV = '/Users/lutz'
   return: '/nas/longleaf/home/lhendri/Users/lutz'

IN
   dirInV
      cell array or single string
   runLocal  ::  logical
      may be [] or missing
%}

lhS = const_lh;

if nargin < 2
   runLocal = lhS.runLocal;
end
if isempty(runLocal)
   runLocal = lhS.runLocal;
end

if runLocal
   % Local: do nothing
   dirOutV = dirInV;
   
else
   % Remote
   if isa(dirInV, 'char')
      dirOutV = modify_dir(dirInV, lhS.remoteBaseDir);
   else
      dirOutV = cell(size(dirInV));
      for i1 = 1 : length(dirInV)
         dirOutV{i1} = modify_dir(dirInV{i1}, lhS.remoteBaseDir);
      end
   end
end

assert(isa(dirOutV, class(dirInV)));

end



%% Local: modify one dir
function outDir = modify_dir(dirIn, baseDir)

% Does dir already start with the remote dir?
if strncmp(dirIn, baseDir, length(baseDir))
   outDir = dirIn;
else
   outDir = fullfile(baseDir, dirIn);
end

end