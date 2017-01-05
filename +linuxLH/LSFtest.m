function tests = LSFtest

tests = functiontests(localfunctions);

end


function commandTest(testCase)
   lS = linuxLH.LSF;
   nCpus = 8;
   lS.command('mFileStr', 'logStr', nCpus)
end