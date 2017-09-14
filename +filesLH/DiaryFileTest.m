function tests = DiaryFileTest

tests = functiontests(localfunctions);

end

function oneTest(testCase)
   compS = configLH.Computer([]);
   fn = fullfile(compS.testFileDir, 'DiaryFileTest.txt');
   dS = filesLH.DiaryFile(fn);
   dS.close;
   dS.clear;
   
   lineV = {'This line should be in diary';  'Another good line'};
   
   dS.open('new');
   disp(lineV{1});
   dS.close;
   disp('This line should NOT be in diary');
   dS.open('append');
   disp(lineV{2});
   dS.close;
   
   tS = filesLH.TextFile(dS.fileName);
   loadV = tS.load;
   assert(isequal(lineV, loadV));
   dS.clear;
   
   
   % Switch to another diary file
   fn2 = fullfile(compS.testFileDir, 'DiaryFileTest2.txt');
   dS = filesLH.DiaryFile(fn, 'new');
   for i1 = 1 : length(lineV)
      disp(lineV{i1});
   end
   dS.close;
   tS = filesLH.TextFile(dS.fileName);
   loadV = tS.load;
   assert(isequal(lineV, loadV));
   
end