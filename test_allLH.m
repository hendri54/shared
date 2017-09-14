function test_allLH
%% Runs all tests
% Also serves as a brief overview of the code
%




%% Config
if false
   % Editor not available on server. Generally not run because of screen display annoyance
   configLH.MatlabEditorStateTest;
   configLH.MatlabEditorTest;
end



% %% Build unit tests
% % Done at the end so results are clearly visible
% 
% testStrV = {};
% 
% testStrV = [testStrV, 'devstructLHtest',  'devvectLHtest',  'ParPoolLHtest',  'ProjectLHtest'];
% % Economics routines
% % testStrV = [testStrV,  {'econLH.BinaryDecisionTest',  'econLH.grid_round_to_test',  'econLH.test_all'}];
% % File routines
% % testStrV = [testStrV,  {'filesLH.FileNamesTest',  'filesLH.TextFileTest',  'filesLH.ZipFileTest'}];
% % Accessing ftp servers
% testStrV = [testStrV, 'KureLHtest'];
% % Latex
% %latexV = {'latexLH.make_command_valid_test',  'latexLH.PreambleTest'};
% % Linux routines
% %linuxV = {'linuxLH.LSFtest', 'linuxLH.SBatchTest'};
% % Maps and containers
% %mapsV = {'mapsLH.StringIntMapTest'};
% % Regression related
% %regressV = 'regressLH.unitTests';
% %vectorV = {'vectorLH.count_elements_test', 'vectorLH.vector2matrix_test'};
% 
% % testStrV = [testStrV, latexV, linuxV, mapsV, regressV, vectorV];
% 
% runtests(testStrV)


%% Tests for entire folders
% There can be other functions ending in `test` in the folder. They are ignored

import matlab.unittest.TestSuite

progDir = fileparts(mfilename('fullpath'));

displayV = [TestSuite.fromFolder(progDir),  TestSuite.fromPackage('checkLH'),  ...
   TestSuite.fromPackage('cellLH'),  TestSuite.fromPackage('dataLH'),  ...
   TestSuite.fromPackage('displayLH'),  ...
   TestSuite.fromPackage('distribLH'),  ...
   TestSuite.fromPackage('econLH'),  ...
   TestSuite.fromPackage('figuresLH'),  TestSuite.fromPackage('filesLH'),  TestSuite.fromPackage('formatLH'), ...
   TestSuite.fromPackage('functionLH'),   ...
   TestSuite.fromPackage('globalOptLH'),  ...
   TestSuite.fromPackage('inputLH'),  TestSuite.fromPackage('latexLH'),  ...
   TestSuite.fromPackage('latexLH'),  TestSuite.fromPackage('markovLH'),  ...
   TestSuite.fromPackage('linuxLH'),  TestSuite.fromPackage('mapsLH'),  TestSuite.fromPackage('optimLH'),  ...
   TestSuite.fromPackage('randomLH'),  TestSuite.fromPackage('regressLH'),  TestSuite.fromPackage('sat_actLH'),  ...
   TestSuite.fromPackage('statsLH'),  TestSuite.fromPackage('stringLH'),  TestSuite.fromPackage('structLH'),  ...
   TestSuite.fromPackage('tableLH'),  TestSuite.fromPackage('vectorLH')];

run(displayV);


end