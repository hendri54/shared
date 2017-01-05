function tests = TextFileTest

tests = functiontests(localfunctions);

end


function runTest(testCase)

lhS = const_lh;
testFn = fullfile(lhS.dirS.testFileDir, 'TextFileTest.txt');
tS = filesLH.TextFile(testFn);
tS.open('w');
tS.close;

lineV = {'This is line 1', 'Line 2 here', 'Line 3', '', 'Line 4 was empty'};
tS.write_strings(lineV);

line2V = tS.load;
assert(isequal(lineV(:), line2V(:)))

end