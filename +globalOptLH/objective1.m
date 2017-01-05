function outS = objective1(guessV, doOptimize)
% Objective function for testing

if nargin < 2
   doOptimize = true;
end

% oldSeed = rng;
% rng('default');

outS.solnV = linspace(1, 2, length(guessV))';
outS.guessV = guessV;

% ng = length(guessV);
outS.fVal = norm(guessV(:) - outS.solnV);

if doOptimize
   outS.fVal = 0.5 * outS.fVal;
   outS.exitFlag = randi([-3, 2], [1,1]);
end

% rng(oldSeed);

end