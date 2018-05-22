function tests = mean_weighted_test

tests = functiontests(localfunctions);

end

function baseTest(tS)
   dbg = true;
   rng('default');
   sizeV = [9, 5];
   xM = randn(sizeV);
   wtM = rand(sizeV);
   
   avg = statsLH.mean_weighted(xM, wtM, dbg);
   tS.verifyEqual(sum(xM(:) .* wtM(:)) ./ sum(wtM(:)),  avg,  'AbsTol', 1e-7);
end

function zeroWeightTest(tS)
   dbg = true;
   xM = [1 2; 3 4];
   avg2 = statsLH.mean_weighted(xM, zeros(size(xM)), dbg);
   tS.verifyTrue(isnan(avg2));
end


function emptyInputTest(tS)
   avg = statsLH.mean_weighted([], [], true);
   tS.verifyTrue(isnan(avg));
end


function noValidObsTest(tS)
   xM = [1 2 NaN 3 NaN];
   wtM = ones(size(xM));
   wtM(~isnan(xM)) = 0;
   avg = statsLH.mean_weighted(xM, wtM, true);
   tS.verifyTrue(isnan(avg));   
end


function singleInputsTest(tS)
   xM = uint16(1:10);
   wtM = single(10 : -1 : 1);
   avg = statsLH.mean_weighted(xM, wtM, true);
   avg2 = statsLH.mean_weighted(double(xM), double(wtM), true);
   tS.verifyEqual(avg, avg2, 'AbsTol', 1e-8);
end


function sizeMismatchTest(tS)
   tS.verifyError(@()  statsLH.mean_weighted(1:3, 1:5, true),  'mean_weighted:SizeMismatch');
end