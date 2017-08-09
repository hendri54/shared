function outStr = file_path(inStr)
% Format a file path for display by removing common directories

% fs = filesep;
% [fDir, fName, fExt] = fileparts(inStr);

% Projects dir
[x,y] = regexp(inStr, '(/projects/p\d+/)');
if length(x) == 1
   outStr = inStr((y+1) : end);
   return;
end

% Dropbox dir
[x,y] = regexp(inStr, '/Dropbox/');
if length(x) == 1
   outStr = inStr((y+1) : end);
   return;
end

% Do nothing
outStr = inStr;

end