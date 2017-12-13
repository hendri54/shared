function exitFlag = mkdir(dirName, dbg)
% Make a directory, if it does not exist
%{
All directories leading to dirName are also created

Algorithm:
   Break path into list of directories
   Create sequentially all that are needed

IN:
   dirName :: string
      A full path. Not relative.

OUT:
   exitFlag
      1: created
      0: exists
      -1: failed
%}

% For testing: show but do not do anything
showOnly = false;
fs = filesep;


%% Input check

if nargin < 2
   dbg = 1;
end

if ~ischar(dirName)
   error('String required');
end

if dirName(1) ~= fs
   disp(dirName);
   error('Must be a full path');
end

% Reject if name contains period. Then assume it is a file name
%  Cannot do that. Fails on Kure
% idxV = strfind(dirName, '.');
% if length(idxV) > 0
%    warnmsg([ mfilename, ':  Directory name contains period' ]);
%    keyboard;
% end

% If input dir does not end in '/', append it
if dirName(end) ~= fs
   dirName = [dirName, fs];
end

% Make sure this is a directory, not a file name
% Does not work: there is no way of telling this from a file name
if 0
   pathName = fileparts(dirName);
   if dirName(end) == fs
      pathName = [pathName, fs];
   end
   if length(pathName) ~= length(dirName)
      warnmsg([ mfilename, ':  Not a directory?' ]);
      keyboard;
   end
end


%% Main

% Does directory exist?
if exist(dirName, 'dir')
   exitFlag = 0;

else
   exitFlag = -1;
   
   % Split dir into levels
   %  First entry is []
   dirV = strsplit(dirName, filesep);
   % Last entry may also be [] b/c of trailing '/'
   if isempty(dirV{end})
      dirV(end) = [];
   end
   
   % Directory created so far
   parentDirStr = [fs, dirV{2}];
   if ~exist(parentDirStr, 'dir')
      error('Top level dir must exist');
   end

   % For each level, check whether it exists
   for i1 = 3 : length(dirV)
      % The dir we are making now
      currentDirStr = fullfile(parentDirStr, dirV{i1});
      if exist(currentDirStr, 'dir')
         if showOnly
            disp([currentDirStr,  ' exists']);
         end
      else
         % Make the dir in its parent
         disp(['Creating  ',  parentDirStr,  '  -  ',  dirV{i1}]);
         if showOnly
            exitFlag = 1;
         else
            mkdir(parentDirStr, dirV{i1});
            exitFlag = 1;
         end
      end
      parentDirStr = currentDirStr;
   end
end

end % eof
