function UtilCrraLHtest

disp('Testing UtilCrraLH');

dbg = 111;
pBeta = 0.95;
pFactor = 0.3;
R = 1.04;

for pSigma = [2, 1, 0.5];
   for nInd = [1, 20]
      uS = UtilCrraLH(pSigma, pBeta, pFactor);

      T = 5;
      rng(21);
      c_itM = rand(nInd, T) + 2;
      [util_itM, mu_itM] = uS.util(c_itM, dbg);
      validateattributes(mu_itM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive', ...
         'size', [nInd, T]})

      % Test marginal utility
      dc = 1e-6;
      util2_itM = uS.util(c_itM + dc, dbg);
      mu2_itM = (util2_itM - util_itM) ./ dc;
      checkLH.approx_equal(mu2_itM, mu_itM, [], 1e-4);

      % Lifetime utility
      uS.lifetime_util(c_itM, dbg);
      
      cGrowth = uS.c_growth(R, dbg);
      
      % Present value of consumption
      c1 = 3.2;
      T = 20;
      pvCons = uS.pv_consumption(c1, R, T, dbg);
      ctV = c1 .* ((1 + cGrowth) .^ (0 : (T-1)));
      pvCons2 = econLH.present_value(ctV, R-1, 1, dbg);
      checkLH.approx_equal(pvCons2, pvCons, 1e-6, []);
      
      
      % Check Euler
      [~, muV] = uS.util(ctV, dbg);
      checkLH.approx_equal(muV(1 : (T-1)), muV(2 : T) .* uS.pBeta .* R, [], 1e-4);
      
      
      % Check that the right present value of consumption is recovered
      c11 = uS.age1_cons(pvCons, R, T, dbg);
      checkLH.approx_equal(c1, c11, 1e-6, []);
      
      
      % Lifetime utility, given c1
      pvUtil = uS.lifetime_util_c1(c1, R, T, dbg);
      utilV = uS.util(ctV, dbg);
      pvUtil2 = econLH.present_value(utilV, 1/uS.pBeta - 1, 1, dbg);
      checkLH.approx_equal(pvUtil2, pvUtil, 1e-6, []);
   end
end

end