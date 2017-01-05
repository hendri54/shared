function tests = SBatchTest

tests = functiontests(localfunctions);

end


function commandTest(testCase)
   lS = linuxLH.SBatch;
   nCpus = 8;
   lS.command('jobName', 'mFileStr', 'logStr', nCpus)
end