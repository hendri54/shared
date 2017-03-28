function tests = rand_discrete_test

tests = functiontests(localfunctions);

end


function oneTest(testCase)

dbg = 111;
rng(40);

nr = 1e4;


% Must test vector and matrix case
for nc = [1, 4]

   uniRandM = rand([nr, nc]);

   n = 4;
   probV = rand([n,1]);
   probV = probV ./ sum(probV);

   % valueV = round(100 .* rand([n,1]));

   outM = randomLH.rand_discrete(probV, uniRandM, dbg);


   for i1 = 1 : n
      frac = sum(outM(:) == i1) ./ (nr * nc);
      checkLH.approx_equal(frac, probV(i1), 1e-2, []);
   %    fprintf('%2i:  prob: %5.2f    frac: %5.2f \n', ...
   %       i1, 100 * probV(i1), 100 * frac);
   end
end


end