function tests = common_base_directory_test

tests = functiontests(localfunctions);

end


function oneTest(testCase)

baseDir = '/Users/lutz';
fileListV = {fullfile(baseDir, 'sub1', 'file1.txt'),  fullfile(baseDir, 'file1.doc'), ...
   fullfile(baseDir, 'sub1', 'sub2', 'file3.txt')};
outDir = filesLH.common_base_directory(fileListV);
testCase.verifyTrue(strcmp(baseDir, outDir));

end