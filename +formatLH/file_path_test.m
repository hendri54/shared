function tests = file_path_test

tests = functiontests(localfunctions);

end

function projectTest(testCase)
   tgStr = 'abc/def_ghi/test.pdf';
   inStr = ['/Users/lutz/Documents/projects/p2017/', tgStr];
   outStr = formatLH.file_path(inStr);
   testCase.verifyEqual(outStr, tgStr);
end

function dropBoxTest(testCase)
   tgStr = 'abc/def_ghi/test.pdf';
   inStr = ['/Users/lutz/Dropbox/', tgStr];
   outStr = formatLH.file_path(inStr);
   testCase.verifyEqual(outStr, tgStr);
end