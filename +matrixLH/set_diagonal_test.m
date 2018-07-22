function tests = set_diagonal_test

tests = functiontests(localfunctions);

end

function oneTest(tS)
   n = 4;
   rng('default');
   inM = rand(n, n);
   
   outM = matrixLH.set_diagonal(inM, 10);
   compare(tS, inM, outM, 10);
end


function nanTest(tS)
   n = 4;
   rng('default');
   inM = rand(n, n);
   inM(2,2) = NaN;
   
   outM = matrixLH.set_diagonal(inM, 10);
   compare(tS, inM, outM, 10);
end


function compare(tS, inM, outM, diagValue)
   n = size(inM, 1);
   tS.verifyEqual(triu(outM, 1), triu(inM, 1), 'AbsTol', 1e-8);
   tS.verifyEqual(tril(outM, -1), tril(inM, -1), 'AbsTol', 1e-8);
   tS.verifyEqual(diag(outM) - diagValue,  zeros(n,1),  'AbsTol', 1e-8);
end