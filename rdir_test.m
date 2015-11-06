function rdir_test
% Note: rdir must be on the path (b/c it is recursive)

disp('Testing rdir');

global lhS
sharedDir = lhS.sharedDirV{1};

outV = rdir(fullfile(sharedDir, '**/c*.m'));

for i1 = 1 : length(outV)
   pathStr = outV(i1).name;
   [fPath, fName, fExt] = fileparts(pathStr);
   if ~strncmpi(fPath, sharedDir, length(sharedDir) - 1)
      error('Wrong path');
   end
   if fName(1) ~= 'c'  &&  fName(1) ~= 'C'
      error('Wrong file name start');
   end
   if ~strcmpi(fExt, '.m')
      error('Wrong extension');
   end
end

end