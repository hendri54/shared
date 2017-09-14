function tests = TextFileTest

tests = functiontests(localfunctions);

end


function runTest(testCase)

compS = configLH.Computer([]);
testFn = fullfile(compS.testFileDir, 'TextFileTest.txt');
tS = filesLH.TextFile(testFn);
tS.open('w');
tS.close;

lineV = {'This is line 1', 'Line 2 here', 'Line 3', '', 'Line 4 was empty'};
tS.write_strings(lineV);

line2V = tS.load;
assert(isequal(lineV(:), line2V(:)))

end


%% Strip formatting
function stripFormattingTest(testCase)

compS = configLH.Computer([]);
testFn = fullfile(compS.testFileDir, 'TextFileTest.txt');
tS = filesLH.TextFile(testFn);
tS.open('w');
tS.close;

trueV = {'This is line 1', 'Line 2 here', 'Line 3', '', 'Line 4 was empty'};
lineV = {'This is <strong>line 1', 'Line 2</strong> here', 'Line 3', '', 'Line 4 was empty'};
tS.write_strings(lineV, true);

line2V = tS.load;
testCase.verifyEqual(trueV(:), line2V(:))


% Strip formatting after writing
tS.clear;
tS.write_strings(lineV, false);
tS.strip_formatting;
line2V = tS.load;
testCase.verifyEqual(trueV(:), line2V(:))


end