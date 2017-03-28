function tests = find_files_containing_strings_test

tests = functiontests(localfunctions);

end


function oneTest(testCase)

baseDir = fileparts(mfilename('fullpath'));
fileMaskIn = '*.txt';
inclSubDirs = true;

findStrV = {'test1', 'test2'};

for useRegEx = [false, true]
   filesLH.find_files_containing_strings(baseDir, fileMaskIn, inclSubDirs, findStrV, useRegEx);
end


end