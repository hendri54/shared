function tests = change_extension_test

tests = functiontests(localfunctions);

end

function Test(testCase)
   dbg = 111;
   inDir = '/Users/lutz/temp';
   fName = 'test_name';
   oldExt = '.dat';
   newExt = '.txt';

   % Extension with '.'
   outFile = filesLH.change_extension(fullfile(inDir, [fName, oldExt]), newExt, true, dbg);
   testCase.verifyEqual(outFile,  fullfile(inDir, [fName, newExt]));
   
   % Extension without '.'
   outFile = filesLH.change_extension(fullfile(inDir, [fName, oldExt]), newExt(2:end), true, dbg);
   testCase.verifyEqual(outFile,  fullfile(inDir, [fName, newExt]));
   
   % Cell array input
   fNameV = {'abc.old', 'defghi.older'};
   outFileV = filesLH.change_extension(fNameV, 'txt', true, dbg);
   testCase.verifyEqual(outFileV,  {'abc.txt', 'defghi.txt'});
   
   % Keep existing
   outFileV = filesLH.change_extension(fNameV, 'txt', false, dbg);
   testCase.verifyEqual(outFileV,  fNameV);
   
   fNameV = {'abc.old', '/Users/temp/defghi'};
   outFileV = filesLH.change_extension(fNameV, 'txt', false, dbg);
   testCase.verifyEqual(outFileV,  {'abc.old', '/Users/temp/defghi.txt'});
   
end