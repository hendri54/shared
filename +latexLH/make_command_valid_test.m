function tests = make_command_valid_test
   tests = functiontests(localfunctions);
end


function oneTest(testCase)
   inStr = 'validOne';
   assert(isequal(latexLH.make_command_valid(inStr), inStr));
   
   inStr = 'valid1more';
   assert(isequal(latexLH.make_command_valid(inStr), 'validOnemore'));
   
   inStr = 'valid_and\\more';
   assert(isequal(latexLH.make_command_valid(inStr), 'validandmore'));
end