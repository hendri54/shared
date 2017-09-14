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

Change: cluster name is hard wired +++++
%}

compS = configLH.Computer([]);

if nargin < 2
   runLocal = compS.runLocal;
end
if isempty(runLocal)
   runLocal = compS.runLocal;
end

if runLocal
   % Local: do nothing
   dirOutV = dirInV;
   
else
   % Remote
   comp2S = configLH.Computer('longleaf');
   if isa(dirInV, 'char')
      dirOutV = modify_dir(dirInV, comp2S.baseDir);
   else
      dirOutV = cell(size(dirInV));
      for i1 = 1 : length(dirInV)
         dirOutV{i1} = modify_dir(dirInV{i1}, comp2S.baseDir);
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