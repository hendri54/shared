function tests = ProbMatrix2Dtest

tests = functiontests(localfunctions);

end


function oneTest(testCase)


nx = 130;
ny = 14;
pr_xyM = rand(nx, ny);
pr_xyM = pr_xyM ./ sum(pr_xyM(:));

pr_xV = sum(pr_xyM, 2);
pr_xV = pr_xV(:);

pr_yV = sum(pr_xyM, 1);
pr_yV = pr_yV(:);

prY_xM = zeros(ny, nx);
prX_yM = zeros(nx, ny);
for ix = 1 : nx
   for iy = 1 : ny
      % Pr(y|x) = Pr(x,y) / Pr(x)
      prY_xM(iy, ix) = pr_xyM(ix, iy) ./ pr_xV(ix);
      prX_yM(ix, iy) = pr_xyM(ix, iy) ./ pr_yV(iy);
   end
end


pmS = statsLH.ProbMatrix2D('prY_xM', prY_xM, 'pr_xV', pr_xV);
check_equal(pmS);

pm2S = statsLH.ProbMatrix2D('pr_xyM', pr_xyM);
check_equal(pm2S);

return;

   %% Nested:  Check that implied fields are correct
   function check_equal(pmS)
      checkLH.approx_equal(prX_yM, pmS.prX_yM, 1e-5, []);
      checkLH.approx_equal(prY_xM, pmS.prY_xM, 1e-5, []);
      checkLH.approx_equal(pr_xyM, pmS.pr_xyM, 1e-5, []);
      checkLH.approx_equal(pr_xV,  pmS.pr_xV, 1e-5, []);
      checkLH.approx_equal(pr_yV,  pmS.pr_yV, 1e-5, []);
   end
end