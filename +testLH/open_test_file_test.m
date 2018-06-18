function tests = open_test_file_test

tests = functiontests(localfunctions);

end

function oneTest(tS)
   fileName = 'open_test_file_test.txt';
   [fid, fPath] = testLH.open_test_file(fileName);
   
   tS.verifyTrue(fid > 0);
   fclose(fid);
   
   tS.verifyTrue(exist(fPath, 'file') > 0);
   
   delete(fPath);
end