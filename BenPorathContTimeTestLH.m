function BenPorathContTimeTestLH

disp('Testing BenPorathContTimeLH');

A = 0.36;
deltaH = 0.03;   
gamma1 = 0.31;
gamma2 = 0.42;
T = 20;
px = 1.8;
r = 0.05;
wage = 2.9;
h0 = 5.8;

bpS = BenPorathContTimeLH(A, deltaH, gamma1, gamma2, T, h0, px, r, wage);

assert(isequal(bpS.gamma, gamma1 + gamma2));


%% Solution

nAge = 100;
ageV = linspace(0, T, nAge);
[nhV, xwV] = bpS.nh(ageV);

xw2V = bpS.x_age(ageV);
checkLH.approx_equal(xw2V, xwV, 1e-4, []);
clear xw2V;

[haV, naV] = bpS.h_age(ageV);
% Code requires interior solution
assert(all(naV < 1));
checkLH.approx_equal(haV(1), h0, 1e-6, []);
checkLH.approx_equal(nhV, haV .* naV, 1e-5, []);

earnV = bpS.age_earnings_profile(ageV);
checkLH.approx_equal(wage .* haV .* (1 - naV) - px .* xwV,  earnV, 1e-4, []);

pvEarn = bpS.pv_earnings;

q_aV = bpS.marginal_value_h(ageV);

m_aV = bpS.m_age(ageV);
mPrime_aV = bpS.mprime_age(ageV);


%% Local functions

foc_check(bpS)
perturbation_test(bpS)
marginal_value_age0_test(bpS);


%% Test m'(a)

dAge = 1e-4;
m_a2V = bpS.m_age(ageV(1 : (nAge-1)) + dAge);
mPrime2V = (m_a2V - m_aV(1 : (nAge-1))) ./ dAge;
checkLH.approx_equal(mPrime_aV(1 : (nAge-1)), mPrime2V, 1e-4, []);


% Test dm/dT

dmdT = bpS.dm_dT(ageV);
dT = 1e-4;
bp2S = BenPorathContTimeLH(A, deltaH, gamma1, gamma2, T + dT, h0, px, r, wage);
m_a2V = bp2S.m_age(ageV);
dmdT2 = (m_a2V - m_aV) ./ dT;
checkLH.approx_equal(dmdT2, dmdT, [], 1e-3);
% fprintf('Max dev dmdT: %f \n',  max(abs(dmdT - dmdT2)));



%% dV/dT

% this is now the same as changing age 0 (b/c of discounting to age 0)

mValue = bpS.marginal_value_T;

dT = 1e-3;
bp2S = BenPorathContTimeLH(A, deltaH, gamma1, gamma2, T + dT, h0, px, r, wage);
pvEarn2 = bp2S.pv_earnings;
mValue2 = (pvEarn2 - pvEarn) ./ dT;


checkLH.approx_equal(mValue, mValue2, 1e-3, []);



%% Test against law of motion

% h-dot against finite difference h(age)
hDotV = bpS.htech(haV, naV, xwV);
hDiffV = diff(haV) ./ diff(ageV);
checkLH.approx_equal(hDiffV,  0.5 .* (hDotV(1 : (nAge-1)) + hDotV(2 : nAge)), 1e-3, []);


% h(a) path given inputs at a point in time
[tOutV, hOutV] = bpS.hpath(bpS.T, ageV, naV, xwV);
% Check against claimed solution
hOut2V = interp1(ageV, haV,  tOutV,  'linear');
checkLH.approx_equal(hOut2V(:), hOutV(:), [],  1e-3);

checkLH.approx_equal(nhV, haV .* naV, 1e-3, []);


% Test against static condition
% Assumes interior n
idxV = find(nhV > 1e-5);
checkLH.approx_equal(xwV(idxV) ./ nhV(idxV),  repmat(bpS.x2nh, size(idxV)),  [],  1e-5);


%% Marginal value of h

dh0 = 1e-4;
bp2S = BenPorathContTimeLH(A, deltaH, gamma1, gamma2, T, h0 + dh0, px, r, wage);
pvEarn2 = bp2S.pv_earnings;
assert(abs(ageV(1)) < 1e-6);
checkLH.approx_equal(q_aV(1), (pvEarn2 - pvEarn) ./ dh0, 1e-3, []);
clear pvEarn2;
clear bp2S;


%% Test (16): closed form solution for lifetime earnings

age = 0;
c1 = bpS.m_age(age) ./ (r + deltaH) .* h0;
c2 = (1 - bpS.gamma) / gamma1 .* (bpS.bracket_term .^ (1 / (1 - bpS.gamma)));
int1 = integral(@int1_nested, age, T);
pvEarn16 = bpS.wage .* (c1 + c2 .* int1);

checkLH.approx_equal(pvEarn16, pvEarn, [], 1e-3);

   function out1 = int1_nested(t)
      out1 = exp(-r .* (t - age)) .* (bpS.m_age(t) .^ (1 / (1 - bpS.gamma)));
   end

% Try another expression
% Fails. Hamiltonian ~= Value function
% pvEarn2 = bpS.wage .* haV(1) .* (1 - naV(1)) - bpS.px .* xwV(1) + q_aV(1) .* bpS.htech(haV(1), naV(1), xwV(1));
% checkLH.approx_equal(pvEarn2, pvEarn, 1e-4, []);


%% My solution for h(a)
% Equivalent to MS's, it turns out

h3V = zeros(size(ageV));
for i1 = 1 : nAge
   age = ageV(i1);
   h3V(i1) = bpS.A .* (bpS.bracket_term .^ (bpS.gamma / (1 - bpS.gamma))) .* ...
      ((gamma2 / gamma1 * wage / px) .^ gamma2) .* exp(-deltaH*age) .* integral(@int_h1, 0, age)  ...
      +  exp(-deltaH .* age) .* h0;
end

checkLH.approx_equal(h3V, haV, 1e-3, []);

   % Nested: integrand
   function outV = int_h1(t)
      outV = bpS.m_age(t) .^ (bpS.gamma ./ (1 - bpS.gamma)) .* exp(deltaH .* t);
   end


%% Test closed form solution for age earnings profile
% It's wrong in the paper

% % m0 = bpS.m_age(0);
% c1V = exp(-deltaH .* ageV) .* h0;
% mAgeV = bpS.m_age(ageV);
% %c3V = bpS.gamma / gamma1 .* (mAgeV .^ (1 / (1 - bpS.gamma)));
% % Dropping extra gamma/gamma1 term in paper
% c3V = (1 + gamma2 / gamma1) .* (mAgeV .^ (1 / (1 - bpS.gamma)));
% 
% earn2V = zeros(size(ageV));
% c2V = zeros(size(ageV));
% for i1 = 1 : length(ageV)
%    age = ageV(i1);
%    if ageV(i1) > 1e-8
%       c2V(i1) = (r + deltaH) / gamma1 * integral(@integ_earn2, 0, ageV(i1));
%    else
%       c2(i1) = 0;
%    end
%    %earn2V(i1) = bpS.wage .* h0 ./ (m0 .^ (1 / (1 - bpS.gamma))) .* (c1V(i1) +  c2 - c3V(i1));
%    earn2V(i1) = bpS.wage .* c1V(i1) +  bpS.wage .* (bpS.bracket_term .^ (1 / (1 - bpS.gamma))) .* (c2V(i1) - c3V(i1));
%    hNew = c1V(i1) + (bpS.bracket_term .^ (1 / (1 - bpS.gamma))) .* c2V(i1);
%    checkLH.approx_equal(hNew, haV(i1), 1e-3, []);
% end
% 
% checkLH.approx_equal(earn2V, earnV, [], 1e-3);
% 
% 
%    % Nested: integrand
%    function out1 = integ_earn2(t)
%       out1 = exp(-deltaH .* (age - t) .* (bpS.m_age(t) .* (bpS.gamma / (1 - bpS.gamma))));
%    end

% paramS.zH = A;
% paramS.deltaH = deltaH;
% paramS.gamma1 = gamma1;
% paramS.gamma2 = gamma2;
% paramS.gamma = bpS.gamma;
% paramS.r = r;
% tgS.intRate = r;
% cS.tgS = tgS;
% s = 5;
% [ha4V, na4V, xw4V] = ojt_solve_ms(ageV(2 : end) + 6 + s, bpS.wage, bpS.px, bpS.T + 6 + s, s, bpS.h0, paramS, cS);
% 
% keyboard;




end



%% Check first order conditions
function foc_check(bpS)
   % Solve for a set of ages
   nAge = 100;
   ageV = linspace(0, bpS.T, nAge);

   xwV = bpS.x_age(ageV);
   [haV, naV] = bpS.h_age(ageV);
   q_aV = bpS.marginal_value_h(ageV);
   
   F_aV = bpS.htech(haV, naV, xwV) + bpS.deltaH .* haV;

   dev13aV = bpS.wage .* haV .* naV - q_aV .* bpS.gamma1 .* F_aV;
   checkLH.approx_equal(dev13aV, zeros(1, nAge), 1e-5, []);

   dev13bV = bpS.px .* xwV - q_aV .* bpS.gamma2 .* F_aV;
   checkLH.approx_equal(dev13bV, zeros(1, nAge), 1e-5, []);
   
   % qdot
   dAge = 1e-3;
   q_a2V = bpS.marginal_value_h(ageV(1 : (nAge-1)) + dAge);
   qDot2V = (q_a2V - q_aV(1 : (nAge-1))) ./ dAge;
   qDotV = bpS.r .* q_aV - q_aV .* (bpS.gamma1 .* F_aV ./ haV - bpS.deltaH) - bpS.wage .* (1 - naV);
   checkLH.approx_equal(qDot2V, qDotV(1 : (nAge-1)), 1e-3, []);
end


%% Test optimality by perturbing solution
function perturbation_test(bpS)
   % Solve for a set of ages
   nAge = 100;
   ageV = linspace(0, bpS.T, nAge);

   xwV = bpS.x_age(ageV);
   [haV, naV] = bpS.h_age(ageV);
   pvEarn = bpS.pv_earnings;

   % Ages for perturbation
   age1 = 1;
   age2 = 2;
   ageIdxV = find(ageV >= age1  &  ageV <= age2);
   % Perturb all
   ageIdxV = 1 : nAge;

   nCases = 5;
   pvEarnV = zeros(nCases, 1);

   % fh = figure('visible', 'on');
   % hold on;

   for iCase = 1 : nCases
      xw2V = xwV;
      na2V = naV;
      if iCase == 1
      elseif iCase == 2
         % Perturb xw up
         xw2V(ageIdxV) = xw2V(ageIdxV) .* 1.02;
      elseif iCase == 3
         % perturb xw down
         xw2V(ageIdxV) = xw2V(ageIdxV) .* 0.98;
      elseif iCase == 4
         % perturb n up
         na2V(ageIdxV) = na2V(ageIdxV) .* 1.02;
      elseif iCase == 5
         % perturb n down
         na2V(ageIdxV) = na2V(ageIdxV) .* 0.98;
      else
         error('invalid');
      end

      % Path of h(t) implied by these inputs
      [t2V, ha2V] = bpS.hpath(bpS.T, ageV, na2V, xw2V);
      hFct = griddedInterpolant(t2V, ha2V, 'linear');

      % Earnings path implied
      earn2V = bpS.wage .* hFct(ageV) .* (1 - na2V) - bpS.px .* xw2V;
      earnFct = griddedInterpolant(ageV, earn2V, 'linear');

   %    plot(ageV, earn2V);

      pvEarnV(iCase) = integral(@integ_earn, 0, bpS.T);
      
      if iCase == 1
         % Should recover optimal solution
         % But the solution is not all that precise
         checkLH.approx_equal(hFct(ageV),  haV, [],  1e-3);
      end
      
   end

   % hold off;
   % keyboard;

   % Should recover optimal solution (not very precise)
   checkLH.approx_equal(pvEarnV(1), pvEarn, [], 1e-3);
   
   % Perturbation should reduce earnings
   assert(all(pvEarnV(2 : end) < pvEarnV(1)));

   % Nested: integrand
   function earnNestV = integ_earn(ageV)
      earnNestV = earnFct(ageV) .* exp(-bpS.r .* ageV);
   end

end


%% Local: Test marginal value of age 0
% -rV + dV/d(age0)
function marginal_value_age0_test(bpS)
   pvEarn = bpS.pv_earnings;
   mValue = bpS.marginal_value_age0;

   dT = 1e-3;
   bp2S = BenPorathContTimeLH(bpS.A, bpS.deltaH, bpS.gamma1, bpS.gamma2, bpS.T - dT, bpS.h0, bpS.px, bpS.r, bpS.wage);
   mValue2 = -bpS.r .* pvEarn + (bp2S.pv_earnings - pvEarn) ./ dT;
   checkLH.approx_equal(mValue, mValue2, 1e-3, []);
   % fprintf('Value of postponing age 0: %.3f / %.3f \n', mValue, mValue2);
   
   if false
      TV = linspace(5, 15, 20)';
      mValueV = zeros(size(TV));
      for i1 = 1 : length(TV)
         bp2S.T = TV(i1);
         mValueV(i1) = bp2S.marginal_value_age0;
      end
      
      disp('    T  -rV + dV/dT');
      disp([TV, mValueV]);
   end

end