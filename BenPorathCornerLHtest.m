function tests = BenPorathCornerLHtest

tests = functiontests(localfunctions);

end


function oneTest(testCase)

disp('Testing BenPorathCornerLH');

%% Set parameters

h0 = 3.4;
z = 0.34;
deltaH = 0.03;
gamma1 = 0.43;
gamma2 = 0.28;
T = 30;
p = 0.74;
r = 0.05;


%% Test cases

for iCase = 1 : 2
   if iCase == 1
      disp('Arbitrary continuation value');
      cvS = BenPorathCornerContValueTestLH;
   elseif iCase == 2
      disp('Ben Porath continuation value');
      % Params must be such that n < 1 after schooling
      zOjt = 0.7 * z;
      pOjt = 1.2 * p;
      wage = 1.23;
      bpS = BenPorathContTimeLH(zOjt, deltaH, gamma1, gamma2, T, 1, ...
         pOjt, r, wage);
      cvS = BenPorathCornerContValueLH(bpS);
      
   else
      error('Invalid');
      
   end


   spS = BenPorathCornerLH(h0, z, deltaH, gamma1, gamma2, T, p, r, cvS);

   check_all(spS);
end


end

% --------- Local function start here


%% Tests
function check_all(spS)
   spS.test_cont_value;
   syntax_tests(spS);
   technology_tester(spS);

   % ***** Solve and check

   schoolS = spS.solve(spS.h0);
   disp('Solution to school problem:');
   disp(schoolS);

   if schoolS.s < 1e-4
      warning('schooling is 0');
   end

   check_age_profiles(schoolS, spS);

   % Check optimality conditions
   check_optimality_ms(schoolS, spS);

   % Check value function
   check_value_ms(schoolS, spS);

   % Check marginal value of s
   check_mvalue_s(spS);
   check_mvalue_h(spS);

   % Check against solution for given s
   if schoolS.s > 0
      check_given_s(schoolS, spS);
   end
end


%% Age profiles
% Given solution
function check_age_profiles(schoolS, spS)
   if schoolS.s > 1
      nAge = round(100 .* schoolS.s);
      ageV = linspace(0, schoolS.s, nAge)';

      [h_aV, xs_aV, q_aV, F_aV] = spS.age_profile(ageV, schoolS.q0, spS.h0);

      hDotV = diff(h_aV) ./ diff(ageV);

      % foc for xs (13b)
      dev13bV = spS.dev_foc_xs(h_aV, xs_aV, q_aV);
      assert(max(abs(dev13bV)) < 1e-4);

      % (13c)
      dev13cV = spS.dev_qdot(ageV, h_aV, xs_aV, q_aV);
      checkLH.approx_equal(dev13cV, zeros(size(dev13cV)), 1e-3, []);

      % (13d)
      rhsV = F_aV - spS.deltaH .* h_aV;
      checkLH.approx_equal(hDotV, 0.5 .* (rhsV(1 : (nAge-1)) + rhsV(2:nAge)), 1e-3, []);

      % qE = q(0)
      checkLH.approx_equal(schoolS.q0, q_aV(1), 1e-4, []);

      % Initial condition
      checkLH.approx_equal(h_aV(1), spS.h0, 1e-4, []);

      % Terminal condition
      checkLH.approx_equal(schoolS.qS,  q_aV(end), 1e-4, []);

      % Check growth rate of xs
      g_xsV = diff(log(xs_aV)) ./ diff(ageV);
      assert(max(abs(g_xsV - spS.g_xs)) < 1e-3);
   end
end


%% Local: check optimality conditions
function check_optimality_ms(schoolS, spS)
   if schoolS.s > 0.01
      devV = spS.dev_given_s_q0(schoolS.s, schoolS.q0, spS.h0);
      checkLH.approx_equal(devV, zeros(size(devV)), 1e-4, []);

      devOptS = spS.marginal_value_s(schoolS);
      checkLH.approx_equal(devOptS, 0, 1e-4, []);
   end

   % eqn for h and q
   [hS, xS, qS] = spS.solve_given_s_q0(schoolS.s, schoolS.q0, spS.h0);
   checkLH.approx_equal([hS, xS, qS], [schoolS.hS, schoolS.xS, schoolS.qS], 1e-4, []);

   devQH = spS.dev_qhG1(schoolS, spS.h0);
   checkLH.approx_equal(devQH, 0, 1e-4, []);

   % q(s) = expression from OJT
   qOjt = spS.cvS.marginal_value_h(schoolS.hS, spS.T - schoolS.s);
   checkLH.approx_equal(schoolS.qS, qOjt, 1e-4, []);
   
%    % If n=1 at start of work, we can check the alternative terminal condition 
%    if sameParams
%       % p 2756 or (27)
%       m6S = spS.bpS.m_age(0);
%       bTerm = spS.bpS.bracket_term;
%       % (27)
%       hS2 = (bTerm .* m6S) .^ (1 / (1 - spS.bpS.gamma));
%       checkLH.approx_equal(hS2, schoolS.hS, [], 1e-3);
%    end
end


%% Local: Solve for given s
function check_given_s(schoolS, spS)
   [marginalValueS, school2S, value] = spS.solve_given_s(schoolS.s, spS.h0);
   checkLH.approx_equal([schoolS.q0, schoolS.xS, schoolS.hS], [school2S.q0, school2S.xS, school2S.hS], ...
      1e-3, []);
   checkLH.approx_equal(marginalValueS, 0, 1e-3, []);

   % Plot deviation from optimal schooling condition against s
   if false
      sV = linspace(6, 14, 30)';
      valueV = zeros(size(sV));
      devOptSV = zeros(size(sV));
      HV = zeros(size(sV));
      dVdsV = zeros(size(sV));
      mvV = zeros(size(sV));
      n0V = zeros(size(sV));
      for i1 = 1 : length(sV)
         [devOptSV(i1), school2S, valueV(i1)] = spS.solve_given_s(sV(i1));
         ds = 1e-3;
         [~,~,value2] = spS.solve_given_s(sV(i1) + ds);
         % Marginal value
         mvV(i1) = (value2 - valueV(i1)) ./ ds .* exp(spS.r .* sV(i1));
         % Hamiltonian
         HV(i1) = -spS.pS .* school2S.xS  +  school2S.qS .* (spS.htech(school2S.hS, school2S.xS) - spS.deltaH * school2S.hS);
         % Marginal value of s on OJT
         dVdsV(i1) = spS.cvS.value_postpone(school2S.hS, spS.T - sV(i1));
         n0V(i1) = spS.cvS.study_time(school2S.hS, spS.T - sV(i1));
      end
      fprintf(' %10s',  'Schooling',  'mValueS',  'mv',  'Hamilt',  'dVds',  'value',  'n0');
      fprintf('\n');
      for i1 = 1 : length(sV)
         fprintf(' %10.3f', sV(i1), devOptSV(i1), mvV(i1), HV(i1), dVdsV(i1), valueV(i1) - valueV(1), n0V(i1));
         fprintf('\n');
      end
   end

   
   % Check optimality of s
   ds = 1e-2;
   [~,~, valueHigh] = spS.solve_given_s(schoolS.s + ds, spS.h0);
   [~,~, valueLow] = spS.solve_given_s(schoolS.s - ds, spS.h0);   
   assert(valueHigh < value + 1e-6);
   assert(valueLow  < value + 1e-6);   
end


%% Local: check marginal value of s
function check_mvalue_s(spS)
   s0 = 5;
   ds = 1e-3;
   [marginalValueS,  schoolS,  value] = spS.solve_given_s(s0, spS.h0);
   [marginalValueS2, school2S, value2] = spS.solve_given_s(s0 + ds, spS.h0);
   checkLH.approx_equal(marginalValueS,  (value2 - value) ./ ds * exp(spS.r * s0), [],  1e-3);
end


%% Local: check marginal value of h
function check_mvalue_h(spS)
   h0 = 3.4;
   dh = 1e-3;
   schoolS  = spS.solve(h0);
   school2S = spS.solve(h0 + dh);
   value0   = spS.value_fct(schoolS);
   value2   = spS.value_fct(school2S);
   dVdh = (value2 - value0) / dh;
   checkLH.approx_equal(schoolS.q0,  dVdh,  1e-3, []);
end



%% Local: check value function
function check_value_ms(schoolS, spS)
   disp('Checking value function');
   [value, pvXs] = spS.value_fct(schoolS);
   
   pvXs2 = integral(@integ_value,  0,  schoolS.s);
   checkLH.approx_equal(pvXs, pvXs2, 1e-4, []);
   
   valueOJT = spS.cvS.value(schoolS.hS, spS.T - schoolS.s) .* exp(-spS.r * schoolS.s);
   
   value2 = - pvXs2 + valueOJT;
   checkLH.approx_equal(value2, value, 1e-4, []);
   
   % Nested: integrand
   function outV = integ_value(ageV)
      xsV = spS.x_age(ageV, schoolS.q0, spS.h0);
      outV = exp(-spS.r .* ageV) .* spS.pS .* xsV;
   end
end


%% Local: syntax tests
function syntax_tests(spS)
   n = 10;
   ageV = linspace(0, spS.T - 1, n)';
   h_aV = spS.h0 .* linspace(1, 2, n)';
   x_aV = linspace(3, 2, n)';
   q_aV = linspace(0.9, 0.3, n)';
   q0 = q_aV(1);
   h0 = h_aV(1);

   spS.dev_foc_xs(h_aV, x_aV, q_aV);
   spS.dev_qdot(ageV, h_aV, x_aV, q_aV);

   spS.h_age(ageV, q0, h0);
   spS.x_age(ageV, q0, h0);
   spS.q_age(ageV, h_aV, q0, h0);
   spS.age_profile(ageV, q0, h0);

   sV = linspace(0.1, spS.T - 1, n)';
   spS.solve_given_s_q0(sV, q0, spS.h0);
   
   schoolS.s = 0.3 * spS.T;
   schoolS.hS = 3.1;
   schoolS.qS = 0.79;
   schoolS.xS = 0.39;
   spS.marginal_value_s(schoolS);
   
   spS.dev_given_s_q0(sV(2), q0, spS.h0);
   
   spS.value_fct(schoolS);
   
   spS.solve_s0(spS.h0);
   spS.solve_given_s(schoolS.s, []);
   
   spS.solve([]);
end


%% Local: Technology
function technology_tester(spS)
   n = 10;
   h_aV = linspace(1, 2, n)';
   x_aV = linspace(3, 2, n)';

   FV = spS.htech(h_aV, x_aV);
   dFdhV = spS.dFdh(h_aV, x_aV);
   dFdxV = spS.dFdx(h_aV, x_aV);

   dh = 1e-4;
   dFdh2V = (spS.htech(h_aV + dh, x_aV) - FV) ./ dh;
   checkLH.approx_equal(dFdh2V, dFdhV, 1e-4, []);

   dx = 1e-4;
   dFdx2V = (spS.htech(h_aV, x_aV + dx) - FV) ./ dx;
   checkLH.approx_equal(dFdx2V, dFdxV, 1e-4, []);
end