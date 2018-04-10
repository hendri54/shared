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



%% Tests for entire folders
% There can be other functions ending in `test` in the folder. They are ignored

progDir = fileparts(mfilename('fullpath'));
testLH.TestAll(progDir);


end