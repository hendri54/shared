function tests = archive_test

tests = functiontests(localfunctions);

end


function oneTest(testCase)
   compS = configLH.Computer([]);
   dir1 = compS.testFileDir;
   
   testDir = 'test1';
   fListV = cell(2, 1);
   for i1 = 1 : length(fListV)
      fListV{i1} = fullfile(dir1, sprintf('test%i.txt', i1));
   end
   
   filesLH.archive(fListV, testDir);

end