function tests = FolderTest

tests = functiontests(localfunctions);

end


function oneTest(testCase)

compS = configLH.Computer([]);
fPath = compS.sharedDirV{1};

f = filesLH.Folder(fPath);

fileListV = f.get_all_files('c*.m');
% Check that all files fit the pattern
for i1 = 1 : length(fileListV)
   [~, fName, fExt] = fileparts(char(fileListV(i1)));
   assert(strcmpi(fName(1), 'c'));
   assert(strcmpi(fExt, '.m'));
end

end