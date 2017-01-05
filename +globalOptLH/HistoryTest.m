function HistoryTest


%% Make inputs

rng('default')

guessLen = 5;
n = 9;

guessM = rand(guessLen, n);
solnM  = rand(guessLen, n);
fValV = 10 * rand(n, 1);
exitFlagV = randi([-3, 2], [n, 1]);



%% Test

hS = globalOptLH.History(guessLen);

% Retrieve from empty
nOut = 5;
fValOut = retrieve_best(hS, nOut);
assert(isempty(fValOut));

% Add
for i1 = 1 : n
   hS.in_basin(guessM(:, i1));
   hS.add(guessM(:, i1),  solnM(:, i1),  fValV(i1),  exitFlagV(i1));
   fValOutV = retrieve_best(hS, nOut);
   
   if i1 > 1
      fValSoFarV = fValV(1 : i1);
      exitFlagSoFarV = exitFlagV(1 : i1);
      fValSortV = sort(fValSoFarV(exitFlagSoFarV > 0));
      if ~isempty(fValSortV)
         checkLH.approx_equal(fValSortV, fValOutV(1 : length(fValSortV)), 1e-8, []);
      end
   end
end



end