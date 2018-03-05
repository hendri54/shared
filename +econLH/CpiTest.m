function tests = CpiTest

tests = functiontests(localfunctions);

end

function oneTest(tS)
   baseYear = 2005;
   compS = configLH.Computer([]);
   cpiFn = fullfile(compS.testFileDir, '/cpi_all_urban.txt');
   cpiS = econLH.Cpi(baseYear, cpiFn);

   cpiV = cpiS.retrieve(1920 : 10 : 1950);
   tS.verifyTrue(all(isreal(cpiV))  &&  all(cpiV > 0));

   tS.verifyEqual(cpiS.retrieve(baseYear), 1);
end