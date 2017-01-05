function tests = ZipFileTest

tests = functiontests(localfunctions);

end


function zipTest(testCase)
   lhS = const_lh;
   zipFn = fullfile(lhS.dirS.testFileDir,  'ZipFileTest1.zip');
   zS = filesLH.ZipFile(zipFn);
   
   % Add files
   %  Could test this more formally. Currently relying on manual inspection of the zip file +++
   fnListV = {'const_lh.m',  'errorLH.m'};
   zS.add_files(fnListV);

end