function tests = is_on_path_test

tests = functiontests(localfunctions);

end

function yesTest(testCase)
   testCase.verifyTrue(filesLH.is_on_path('pinv'));
end


function noTest(testCase)
   testCase.verifyFalse(filesLH.is_on_path('no_no_no'));
end


%% Test something in package folder
function packageTest(testCase)
   testCase.verifyTrue(filesLH.is_on_path('filesLH.is_on_path'));
end