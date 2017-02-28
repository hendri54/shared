function tests = paper_format_test

tests = functiontests(localfunctions);

end


function oneTest(testCase)
   lhS = const_lh;
   dir1 = lhS.dirS.testFileDir;
   preambleFn = fullfile(dir1, 'paper_format_preamble.tex');
   
   %%  Make a preamble for testing
   
   pS = latexLH.Preamble(preambleFn);
   pS.initialize;
   
   commandV = {'cmdOne', 'commandTwo', 'cThree', 'cThreeOne'};
   valueV   = {'valueOne', 'vTwo', 'xThree', '31'};
   commentV = {'Comment one',  'Second comment',  'Third comment', 'Longer command 31'};
   for i1 = 1 : length(commandV)
      pS.append(commandV{i1}, valueV{i1}, commentV{i1});
   end
   
   
   %% Run replacement
   
   paperFn = fullfile(dir1, 'paper_format_doc.txt');
   preambleFnV = {preambleFn};
   econLH.paper_format(paperFn, preambleFnV);
   
end