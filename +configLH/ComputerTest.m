function tests = ComputerTest

tests = functiontests(localfunctions);

end

function localTest(testCase)
   cS = configLH.Computer('local');
   testCase.verifyEqual(cS.sharedBaseDir, '/Users/lutz/Documents/econ/Matlab');
end

function longleafTest(testCase)
   cS = configLH.Computer('longleaf');
   testCase.verifyEqual(cS.sharedBaseDir,  '/nas/longleaf/home/lhendri/Documents/econ/Matlab')
end