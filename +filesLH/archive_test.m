function tests = archive_test

tests = functiontests(localfunctions);

end


function oneTest(testCase)
   lhS = const_lh;
   dir1 = lhS.dirS.testFileDir;
   
   testDir = 'test1';
   fListV = cell(2, 1);
   for i1 = 1 : length(fListV)
      fListV{i1} = fullfile(dir1, sprintf('test%i.txt', i1));
   end
   
   filesLH.archive(fListV, testDir);

end