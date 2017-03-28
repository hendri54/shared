function tests = ask_confirm_test

tests = functiontests(localfunctions);

end

function oneTest(testCase)
if ~inputLH.ask_confirm('Test', 'noconfirm')
   error('Invalid');
end

end