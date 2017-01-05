function tests = test_all

tests = functiontests(localfunctions);

end


function WageRegressionLHtest(testCase)
   econLH.WageRegressionLHtest(testCase);
end

function PaperFiguresTest(testCase)
   econLH.PaperFiguresTest(testCase);
end