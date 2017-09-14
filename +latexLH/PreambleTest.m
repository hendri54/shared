function tests = PreambleTest
   tests = functiontests(localfunctions);
end

function oneTest(testCase)
   fileName = 'PreambleTest.tex';
   pS = make_preamble(fileName, 1, 5);
   
   % Check that the lines were written correctly
   lineV = pS.tFile.load;

   assert(isequal(lineV{1},  '% comment1'));
   assert(isequal(lineV{2},  '\newcommand{\fieldOne}{command1}'))
   
   
   % Extract commands and values
   [cmdV, valueV] = pS.extract_commands;
   assert(isequal(cmdV{1}, '\fieldOne'));
   assert(isequal(valueV{1}, 'command1'));
   assert(isequal(cmdV{5}, '\fieldFive'));
   assert(isequal(valueV{5}, 'command5'));
end


%% Compare two preambles
function compareTest(testCase)
   fileName = 'PreambleTest.tex';
   pS = make_preamble(fileName, 1, 5);
   fileName2 = 'PreambleTest2.tex';
   p2S = make_preamble(fileName2, 3, 8);
   
   pS.compare(p2S);
end



%% Make preamble for testing
function pS = make_preamble(fileNameIn, n1, n2)
   compS = configLH.Computer([]);
   fileName = fullfile(compS.testFileDir, fileNameIn);
   pS = latexLH.Preamble(fileName);
   pS.initialize;
   
   for i1 = n1 : n2
      if i1 < n1 + 3
         commentStr = sprintf('comment%i', i1);
      else
         commentStr = [];
      end
      pS.append(sprintf('field%i', i1), sprintf('command%i', i1), commentStr);
   end
   
   pS.close;
end