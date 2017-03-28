function tests = does_file_contain_strings_test

tests = functiontests(localfunctions);

end


function oneTest(testCase)

testDir = fileparts(mfilename('fullpath'));
findStrV = {'test1', 'test2'};
filePath = fullfile(testDir, 'does_file_contain_strings_testfile.txt');

for useRegEx = [false, true]
   foundV = filesLH.does_file_contain_strings(filePath, findStrV, useRegEx);
   if ~isequal(foundV(:), [true; false])
      error('Wrong result');
   end
end


end