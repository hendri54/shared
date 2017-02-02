function tests = PreambleTest
   tests = functiontests(localfunctions);
end

function oneTest(testCase)
   lhS = const_lh;
   fileName = fullfile(lhS.dirS.testFileDir, 'PreambleTest.tex');
   pS = latexLH.Preamble(fileName);
   pS.initialize;
   
   for i1 = 1 : 5
      if i1 < 3
         commentStr = sprintf('comment%i', i1);
      else
         commentStr = [];
      end
      pS.append(sprintf('field%i', i1), sprintf('command%i', i1), commentStr);
   end
   
   pS.close;
   
   % Check that the lines were written correctly
   lineV = pS.tFile.load;

   assert(isequal(lineV{1},  '% comment1'));
   assert(isequal(lineV{2},  '\newcommand{\fieldOne}{command1}'))
end