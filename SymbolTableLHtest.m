function tests = SymbolTableLHtest

tests = functiontests(localfunctions);

end


function oneTest(testCase)

compS = configLH.Computer([]);

disp('Test SymbolTableLH');

nameV = {'pAlpha', 'pBeta'};
symbolV = {'\alpha', '\beta_{x}'};

tS = SymbolTableLH(nameV, symbolV);

% Add 1 element
tS.add('pGamma', '\gamma');

% Add multiple elements
tS.add({'pZeta', 'pMu'},  {'\zeta', '\mu'});

% Retrieve
symbolStr = tS.retrieve('pGamma');
if ~strcmp(symbolStr, '\gamma')
   error('Retrieve failed');
end

% Write preamble
fPath = fullfile(filesLH.fullpaths(compS.sharedDirV{1}), 'SymbolTableLH_preamble.tex');
tS.preamble_write(fPath);

end