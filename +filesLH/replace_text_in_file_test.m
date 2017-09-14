function tests = replace_text_in_file_test

tests = functiontests(localfunctions);

end


function oneTest(testCase)

compS = configLH.Computer([]);
testDir = compS.testFileDir;

filePath0 = fullfile(testDir, 'replace_text_in_file_test0.txt');
filePath1 = fullfile(testDir, 'replace_text_in_file_test1.txt');

% Copy so that one file never changes
copyfile(filePath0, filePath1);

oldTextV = {'cS.v',  'Policy', '/line', '\_one', '\\line', 'with/sl', 'with\back', '{\\macro}'};
newTextV = {'newS.v', 'new2', 'Xline',  'Yone', 'Zline', 'withXsl',  'withXback',  'MACRO'};

filesLH.replace_text_in_file(filePath1, oldTextV, newTextV);


end