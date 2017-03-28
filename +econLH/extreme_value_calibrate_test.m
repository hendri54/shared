function tests = extreme_value_calibrate_test

tests = functiontests(localfunctions);

end


function oneTest(testCase)

dbg = 111;

doProfile = false;

if doProfile
   dbg = 0;
   nIter = 30;
   profile off;
   profile clear;
end

nInd = 100;
nx = 5;

prefScale = 0.3;
choiceFracV = linspace(1, 2, nx)';
choiceFracV = choiceFracV ./ sum(choiceFracV);
value_ixM = linspace(1, 2, nInd)' * linspace(1, 1.5, nx);

% Change the problem so that one option is very unattractive
value_ixM(:, 2) = value_ixM(:, 2) - 2;


% Show choice probs with 0 mean preferences
% Problem is rigged so that one of them is 0
prob_ixM = econLH.extreme_value_decision(value_ixM, prefScale, dbg);
probV = mean(prob_ixM);
fprintf('Choice probs with 0 mean prefs:  ');
fprintf('%6.3f', probV);
fprintf('\n');

fZeroOptS = optimset('fzero');
fZeroOptS.TolFun = 1e-4;

fmbOptS = optimset('fminsearch');
fmbOptS.TolFun = 1e-5;


%% A loop for profiling

if doProfile
   profile off;
   profile clear;
   profile on;
end
for i1 = 1 : 1e2
   % Calibrate
   prefMeanV = econLH.extreme_value_calibrate(value_ixM, choiceFracV, prefScale, fZeroOptS, fmbOptS, dbg);
end
if doProfile
   profile report;
   profile off;
end
   
% Check that choice probs are correct
prob_ixM = econLH.extreme_value_decision(value_ixM + ones(nInd,1) * prefMeanV(:)', prefScale, dbg);
probV = mean(prob_ixM);
if any(abs(probV(:) - choiceFracV) > 1e-3)
   error('Wrong solution');
end



end