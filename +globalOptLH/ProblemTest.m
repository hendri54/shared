function tests = ProblemTest

tests = functiontests(localfunctions);

end


function oneTest(testCase)

lhS = const_lh;
%rng('default');

n = 5;
guessV = linspace(4, 1.5, n);
guessLbV = ones(1, n);
guessUbV = 5 * ones(1, n);
fHandle = @globalOptLH.objective1;
historyFn = fullfile(lhS.dirS.tempDir, 'ProblemTestHistory.mat');

% why does this not produce a reproducible result? +++++

% Not for testing because of screen annoyance
showProgressGraph = false;
pS = globalOptLH.Problem(fHandle, guessV, 'maxTime', 0.5, 'guessLbV', guessLbV, 'guessUbV', guessUbV, ...
   'historyFn', historyFn,  'probRejectInBasin', 0.3,  'showProgressGraph', showProgressGraph);

hfS = pS.solve;

histS = hfS.load;


end