function BackwardInductionTest

dbg = 111;
uFct = @(c) log(c);
kMin = -1;
kMax = 10;
nk = 20;
kGridV = linspace(kMin, kMax, nk);
nj = 3;
vPrime_kjM = log(linspace(1, 3, nk))' * linspace(1, 1.5, nj);
prob_jV = linspace(2, 1, nj)';
prob_jV = prob_jV ./ sum(prob_jV);

y = 5;
bConstraint = econLH.BackwardInductionTestBc(kMin, y);

[kPrime_kV, c_kV, v_kV] = econLH.BackwardInduction(uFct, bConstraint, kGridV, vPrime_kjM, prob_jV, dbg);


%% Test by simulation

nc = 10;

% Check solution for each k
for ik = 1 : nk
   k = kGridV(ik);
   cOpt = c_kV(ik);
   vOpt = v_kV(ik);
   
   % Check value of deviating from cOpt on a grid
   cGridV = linspace(0.8, 1.2, nc) * cOpt;
   % Also check that we recover vOpt for cOpt
   cGridV(end) = cOpt;
   
   v_cV = zeros(nc, 1);
   for ic = 1 : nc
      c = cGridV(ic);
      kPrime = bConstraint.getKPrime(k, c);
      % k' must be interior
      if kPrime > kMin  &&  kPrime < kMax  &&  c > 1e-3
         vPrime_jV = zeros(nj, 1);
         for j = 1 : nj
            vPrime_jV(j) = interp1(kGridV, vPrime_kjM(:, j), kPrime, 'linear', 'extrap');
         end
         v = uFct(c) + sum(vPrime_jV .* prob_jV);
         v_cV(ic) = v;
         
         if ic < nc
            assert(v < vOpt);
         else
            % There is a bit of a discrepancy b/c the interpolation here works differently
            checkLH.approx_equal(v, vOpt, 5e-3, []);
         end
      end
   end
end

end