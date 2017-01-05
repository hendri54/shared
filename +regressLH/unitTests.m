%% Unit test functions
% Must be a caller with local functions
function tests = unitTests
   tests = functiontests(localfunctions);
end

% Simply call free standing functions
function dummy_pointers_test(testCase)
   regressLH.dummy_pointers_test(testCase);
end

function find_regressors_test(testCase)
   regressLH.find_regressors_test(testCase);
end

