function [prefMeanV, exitFlag, prob_ixM] = extreme_value_calibrate(value_ixM, choiceFracV, prefScale, fZeroOptS, fmbOptS, dbg)
% Calibrate a discrete decision problem with type I extreme value shocks
%{
The agents maximizes from a set with payoffs
   value_ixM(i,x) + prefMean(x) - prefShock(x) / prefScale
   prefMean(1) = 0
The task is to find the prefMean vector such that fraction choiceFracV(x) chooses option x

IN
   fZeroOptS
      options for fzero, may be []
      best to provide if speed is important
      set TolFun about 1e-4
   fmbOptS
      options for fminsearch, may be []
      best to provide if speed is important
      set TolFun about 1e-5

OUT
   prefMeanV
      see equation
   exitFlag
      standard optimization exitFlag; indicates whether solution was found
   prob_ixM
      prob that person i chooses option x

Extensions:
   allow mass of agents to differ
%}

nInd = size(value_ixM, 1);
nx = length(choiceFracV);

%% Input check
if dbg > 10
   validateattributes(value_ixM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', ...
      'size', [nInd, nx]})
   checkLH.prob_check(choiceFracV, 1e-6);
   validateattributes(prefScale, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', ...
      'scalar',  '>', 0.05})
end


%% For each pair: find bounds of mean pref

if isempty(fZeroOptS)
   fZeroOptS = optimset('fzero');
   fZeroOptS.TolFun = 1e-4;
end

meanPrefBoundM = zeros(nx, 2);
for ix = 2 : nx
   % Lower bound on meanPref(ix): at least choiceFracV(ix) must prefer ix over 1
   fracX = choiceFracV(ix);
   meanPrefBoundM(ix, 1) = pairwise_calibration(value_ixM(:, [1, ix]), [1-fracX, fracX], prefScale, fZeroOptS, dbg);
   
   % Upper bound: at least choiceFracV(1) must prefer 1 over ix
   fracX = 1 - choiceFracV(1);
   meanPrefBoundM(ix, 2) = pairwise_calibration(value_ixM(:, [1, ix]), [1-fracX, fracX], prefScale, fZeroOptS, dbg);
end

validateattributes(meanPrefBoundM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', ...
   'size', [nx, 2]})


%% Calibrate using these bounds

% Guess: mean of those bounds
guessV = mean(meanPrefBoundM(2 : nx, :), 2);

% Check that all probabilities are interior for this guess
[~, probV] = local_dev(guessV);
if any(probV < 1e-4)
   warning('Guess does not produce interior solution');
end

if isempty(fmbOptS)
   fmbOptS = optimset('fminsearch');
   fmbOptS.TolFun = 1e-5;
end
[solnV, ~, exitFlag] = fminsearch(@local_dev, guessV, fmbOptS);

if exitFlag <= 0
   warning('No solution found');
end

prefMeanV = [0; solnV(:)];

% Choice probabilities
[~, prob_ixM] = choice_probs(value_ixM, prefMeanV, prefScale, dbg);


%% Output check
if dbg > 10
   validateattributes(prefMeanV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', ...
      'size', [nx, 1]})
end

return;  % end of main function


%% Local: Deviation from choice fractions
   function [dev, probV] = local_dev(guessV)
      prefMeanV = [0; guessV(:)];
      probV = choice_probs(value_ixM, prefMeanV, prefScale, dbg);
      dev = sum((probV - choiceFracV) .^ 2) .* 100;
      
      % Penalty when any probability is very small
      if any(probV < 1e-4)
         dev = dev + 1e8 .* sum(max(0, 1e-4 - probV));
      end
   end

end


%% Compute choice probabilities
function [probV, prob_ixM] = choice_probs(value_ixM, prefMeanV, prefScale, dbg)
   nInd = size(value_ixM, 1);
   prob_ixM = econLH.extreme_value_decision(value_ixM + ones(nInd,1) * prefMeanV(:)', prefScale, dbg);
   %probV = mean(prob_ixM)';'
   % This is 15 times faster than calling mean
   probV = sum(prob_ixM)' ./ nInd;
end


%% Find bounds for pairwise comparison
% x vs 1
% This is the most expensive part of the process
function meanPref = pairwise_calibration(value_ixM, choiceFracV, prefScale, optS, dbg)

nInd = size(value_ixM, 1);

% ******  Input check
if dbg > 10
   validateattributes(value_ixM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', ...
      'size', [nInd, 2]})
   if length(choiceFracV) ~= 2
      error('Invalid');
   end
   checkLH.prob_check(choiceFracV(:), 1e-6);
end


% ******  Calibration

% Starting point: such that median person is indifferent
medianGap = median(value_ixM(:, 2) - value_ixM(:, 1));

[meanPref, ~, exitFlag] = fzero(@pairwise_dev, medianGap, optS);
if exitFlag <= 0
   warning('No solution found');
end


% *******  Output check

if dbg > 10
   validateattributes(meanPref, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'scalar'})
end

return; % end of main function

   function dev = pairwise_dev(guess)
      prob_ixM = econLH.extreme_value_decision([value_ixM(:,1), value_ixM(:,2) + guess], prefScale, dbg);
      % prob2 = mean(prob_ixM(:,2));
      % This is 15 times faster than calling `mean`!
      prob2 = sum(prob_ixM(:,2)) ./ size(prob_ixM, 1);
      dev = prob2 - choiceFracV(2);
   end

end