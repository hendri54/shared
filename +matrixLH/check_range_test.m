function tests = check_range_test

tests = functiontests(localfunctions);

end

function oneTest(tS)
   rng('default');
   xRangeV = [-2, 1];
   xTol = 1e-6;
   inM = linspace(xRangeV(1) - 0.5 .* xTol, xRangeV(2) + 0.5 .* xTol, 30)' * ones(1,3);
   
   tS.verifyTrue(any(inM(:) > xRangeV(2)));
   tS.verifyTrue(any(inM(:) < xRangeV(1)));
   
   outM = matrixLH.check_range(inM, xRangeV, xTol);
   
   tS.verifyTrue(all(outM(:) <= xRangeV(2)));
   tS.verifyTrue(all(outM(:) >= xRangeV(1)));
end