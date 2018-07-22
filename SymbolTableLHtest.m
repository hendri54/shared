function tests = SymbolTableLHtest

tests = functiontests(localfunctions);

end


function oneTest(testCase)

compS = configLH.Computer([]);

disp('Test SymbolTableLH');

nameV = {'pAlpha', 'pBeta'};
symbolV = {'\alpha', '\beta_{x}'};

fPath = fullfile(filesLH.fullpaths(compS.testFileDir), 'SymbolTableLH_preamble.tex');
tS = SymbolTableLH(nameV, symbolV, fPath);

% Add 1 element
tS.add('pGamma', '\gamma');

% Add multiple elements
tS.add({'pZeta', 'pMu'},  {'\zeta', '\mu'});

% Retrieve
symbolStr = tS.retrieve('pGamma');
testCase.verifyEqual(symbolStr, '\gamma')

% Write preamble
tS.preamble_write(fPath);
tS.preamble_write;

end