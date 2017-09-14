function tests = HistoryFileTest

tests = functiontests(localfunctions);

end


function oneTest(testCase)

rng('default');

compS = configLH.Computer([]);
filePath = fullfile(compS.testFileDir,  'HistoryFileTest.mat');

guessLen = 5;
histS = globalOptLH.History(guessLen);
guessV = rand(guessLen, 1);
solnV  = rand(guessLen, 1);
fVal = rand(1,1);
exitFlag = randi([-3, 2], [1,1]);
histS.add(guessV, solnV, fVal, exitFlag);

hfS = globalOptLH.HistoryFile(filePath);
hfS.save(histS);

loadS = hfS.load;
fLoad = loadS.retrieve_best(1);
checkLH.approx_equal(fLoad, fVal, 1e-8, []);

% Add point and test again

fVal2 = fVal + 1;
hfS.add(guessV + 1, solnV + 1, fVal2, exitFlag + 1);
loadS = hfS.load;

fLoad = loadS.retrieve_best(1);
checkLH.approx_equal(fLoad, fVal, 1e-8, []);

fLoadV = loadS.retrieve_best(2);
checkLH.approx_equal(fLoadV, [fVal; fVal2], 1e-8, []);

fLoadV = loadS.retrieve_best(4);
checkLH.approx_equal(fLoadV, [fVal; fVal2], 1e-8, []);

end