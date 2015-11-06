function replace_text_in_file_test

lhS = const_lh;
testDir = lhS.testFileDir;

filePath0 = fullfile(testDir, 'replace_text_in_file_test0.txt');
filePath1 = fullfile(testDir, 'replace_text_in_file_test1.txt');

% Copy so that one file never changes
copyfile(filePath0, filePath1);

oldTextV = {'cS.v',  'Policy', '/line', '\_one', '\\line', 'with/sl', 'with\back'};
newTextV = {'newS.v', 'new2', 'Xline',  'Yone', 'Zline', 'withXsl',  'withXback'};

filesLH.replace_text_in_file(filePath1, oldTextV, newTextV);


end