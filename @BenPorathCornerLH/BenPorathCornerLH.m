% Ben-Porath model with corner solution for n
%{
Technology: z h^gamma1 x^gamma2

Methods not in this file
   solve
      solve school problem
%}
classdef BenPorathCornerLH < handle
   
properties
   h0    double
   % productivity parameter
   z double
   deltaH double
   gamma1 double
   gamma2 double
   % Length of work time
   T double
   % Price of input
   pS double
   % Interest rate
   r  double
   % Continuation value object (for a template, see BenPorathCornerContValueLH)
   cvS
end

properties (Dependent)
   gamma 
   % Growth rate of x(s)
   g_xs
   mu
end

methods
   %% Constructor
   %{
   Test the continuation value function with spS.test_cont_value
   %}
   function spS = BenPorathCornerLH(h0, z, deltaH, gamma1, gamma2, T, pS, r, cvS)
      spS.h0 = h0;
      spS.z = z;
      spS.deltaH = deltaH;
      spS.gamma1 = gamma1;
      spS.gamma2 = gamma2;
      spS.T = T;
      spS.pS = pS;
      spS.r = r;
      spS.cvS = cvS;
      
      spS.validate;
   end
   
   function validate(spS)
      validateattributes(spS.h0, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'scalar', 'positive'})
      assert((spS.deltaH >= 0)  &&  (spS.deltaH < 0.2));
      validateattributes(spS.T, {'double'}, {'finite', 'nonnan', 'nonempty', 'integer', '>', 20, '<', 100})
      assert((spS.r > 0)  &&  (spS.r < 0.15));
      assert(spS.gamma < 0.99);
   end
   
   
   %% Dependent properties
   function gma = get.gamma(spS)
      gma = spS.gamma1 + spS.gamma2;
      assert(gma < 1);
   end
   
   % Checked: 2016-Apr-15
   function gxs = get.g_xs(spS)
      gxs = (spS.r + spS.deltaH .* (1 - spS.gamma1)) ./ (1 - spS.gamma2);
   end
   
   % Checked: 2016-Apr-15
   function muOut = get.mu(spS)
      muOut = (spS.gamma2 * spS.r + spS.deltaH * (1 - spS.gamma1)) / (1 - spS.gamma2);
   end
   
      
   %% Technology
   
   % F(h,x)
   function F_aV = htech(spS, h_aV, xs_aV)
      F_aV = spS.z .* (h_aV .^ spS.gamma1) .* (xs_aV .^ spS.gamma2);
   end

   % Derivatives
   function dFdh_aV = dFdh(spS, h_aV, xs_aV)
      dFdh_aV = spS.gamma1 .* spS.z .* (h_aV .^ (spS.gamma1 - 1)) .* (xs_aV .^ spS.gamma2);
   end

   function dFdx_aV = dFdx(spS, h_aV, xs_aV)
      dFdx_aV = spS.gamma2 .* spS.z .* (h_aV .^ spS.gamma1) .* (xs_aV .^ (spS.gamma2 - 1));
   end

   
   %% Deviations from optimality, given s, q0
   %{
   Must be efficient
   IN
      h0 (optional)
   %} 
   function [devV, schoolS, devOptS, devQH] = dev_given_s_q0(spS, s, q0, h0)
      if isempty(h0)
         h0 = spS.h0;
      end
      schoolS.s = s;
      schoolS.q0 = q0;
      [schoolS.hS, schoolS.xS, schoolS.qS] = spS.solve_given_s_q0(s, q0, h0);
      
      % Deviations:
      % growth of q h^gamma1 (25)
      devQH = spS.dev_qhG1(schoolS, h0);
      % optimality of s
      devOptS = spS.marginal_value_s(schoolS);
      devV = [devQH; devOptS];
      
      validateattributes(devV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'size', [2, 1]})
   end
   
   
   %% Compute h(s), x(s), q(s) given s, q0
   %{
   Must be efficient
   IN
      sV
         years of schooling (corner period)
   OUT
      all at end of corner period
   Checked: 2016-Apr-15
   %}
   function [hSchoolV, xsV, qsV] = solve_given_s_q0(spS, sV, q0, h0)
      if isempty(h0)
         h0 = spS.h0;
      end
      
      assert(all(spS.T - sV > 1e-3), 'Negative time horizon');
      %hSchoolV = zeros(size(sV));
      %qsV = zeros(size(sV));
      
      % For (28)
      c28a = ((h0 ^ (spS.gamma-1)) * spS.z * ((q0 / spS.pS * spS.gamma2) ^ spS.gamma2)) ^ (1/(1-spS.gamma2));
      muValue = spS.mu;
      % (28)
      c28V = 1 + (1 - spS.gamma1) ./ muValue .* c28a * (exp(muValue .* sV) - 1);
      hSchoolV = h0 .* exp(-spS.deltaH .* sV) .* (c28V .^ (1 / (1-spS.gamma1)));
      qsV = spS.cvS.marginal_value_h(hSchoolV, spS.T - sV);
      
%       for i1 = 1 : length(sV)
%          s = sV(i1);
%          % q at end of school = q at start of work
%          qsV(i1) = spS.cvS.marginal_value_h(hSchoolV(i1), spS.T - s);
%       end
      
      validateattributes(hSchoolV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive'})
      validateattributes(qsV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive'})
      
      % Foc for x(a)
      xsV = (spS.z .* spS.gamma2 ./ spS.pS .* qsV .* (hSchoolV .^ spS.gamma1)) .^ (1 ./ (1 - spS.gamma2));
      validateattributes(xsV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive'})
   end   
   
   
   %% Age profiles
   
   % Compute age profile during schooling
   % Checked: 2016-Apr-15
   function [h_aV, xs_aV, q_aV, F_aV] = age_profile(spS, ageV, q0, h0)
      validateattributes(ageV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', '>=', 0})
      h_aV = spS.h_age(ageV, q0, h0);
      xs_aV = spS.x_age(ageV, q0, h0);      
      q_aV = spS.q_age(ageV, h_aV, q0, h0);
      F_aV = spS.htech(h_aV, xs_aV);
   end
   
   
   % h(a) Eqn 22
   %{
   IN
      q0
         q at age 0 (with full T periods to go)
   %}
   function hV = h_age(spS, ageV, q0, h0)
      validateattributes(ageV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', '>=', 0})

      C2 = (h0 .^ (spS.gamma - 1))  .*  ((q0 ./ spS.pS .* spS.gamma2) .^ spS.gamma2)  .*  spS.z;
      C3 = exp(spS.mu .* ageV) - 1;
      C1 = 1 + (1 - spS.gamma1) ./ spS.mu .* (C2 .^ (1 / (1-spS.gamma2))) .* C3;

      hV = h0 .* exp(-spS.deltaH .* ageV) .* (C1 .^ (1 / (1 - spS.gamma1)));

      validateattributes(hV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive', 'size', size(ageV)})
   end   
   
   
   % xs(a) from (21)
   function xsV = x_age(spS, ageV, q0, h0)
      % x(0) ^ (1 - gamma2) = c1
      c1 = (h0 ^ spS.gamma1) .* q0 ./ spS.pS .* spS.gamma2 .* spS.z;

      c2 = exp(spS.g_xs .* ageV);

      xsV = c1 .^ (1 / (1 - spS.gamma2)) .* c2;
      validateattributes(xsV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', '>=', 0, 'size', size(ageV)})
   end
   
   
   % q(a) h(a) ^ gamma1
   % Checked: 2016-Apr-15
   function qhG1_aV = qhG1(spS, ageV, q0, h0)
      % (25)
      qhG1_aV = q0 .* (h0 .^ spS.gamma1) .* exp((spS.r + spS.deltaH .* (1 - spS.gamma1)) .* ageV);
   end
   
   % q(a)
   function q_aV = q_age(spS, ageV, h_aV, q0, h0)
      % (q(a) * h(a)) ^ gamma1 from (25)
      qhV = spS.qhG1(ageV, q0, h0);
      q_aV = qhV ./ (h_aV .^ spS.gamma1);
   end
   
   
   %% Deviations from optimality conditions
   
   % Marginal value of increasing s
   %{
   Returns the marginal value of increasing s
      discounted to age s
   devOptS = 0 for interior s
   
   Checked: 2016-Apr-15
   %}
   function devOptS = marginal_value_s(spS, schoolS)
      % -rV + dV/ds, remaining work time is T-s
      dVds = spS.cvS.value_postpone(schoolS.hS, spS.T - schoolS.s);
      
      devOptS = -spS.pS .* schoolS.xS + schoolS.qS .* (spS.htech(schoolS.hS, schoolS.xS) - spS.deltaH .* schoolS.hS) + dVds;
   end

   
   % FOC for xs
   % Checked: 2016-Apr-15
   function devV = dev_foc_xs(spS, h_aV, xs_aV, q_aV)
      devV = spS.pS - q_aV .* spS.dFdx(h_aV, xs_aV);
      validateattributes(devV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real'})
   end   
   
   
   % qDot equation
   %{
   IN
      h_aV, etc
         tight age grids for q,h,x
   %}
   function devV = dev_qdot(spS, ageV, h_aV, x_aV, q_aV)
      qDotV = diff(q_aV) ./ diff(ageV);
      rhsV = q_aV .* (spS.r - spS.dFdh(h_aV, x_aV) + spS.deltaH);
      nAge = length(q_aV);
      devV = qDotV - 0.5 .* (rhsV(1 : (nAge-1)) + rhsV(2:nAge));
   end
   
   % Growth of q h^gamma1
   %{
   qT
      q at start (age 0)
   s
      length of corner period
   hS = h(s)
   qS = q(T - s)
   
   Scaling is important here. Taking the difference makes the deviation non-monotone is s
   
   Checked: 2016-Apr-15
   %}
   function devQH = dev_qhG1(spS, schoolS, h0)
      devQH = spS.qhG1(schoolS.s, schoolS.q0, h0) ./ (schoolS.qS .* (schoolS.hS .^ spS.gamma1)) - 1;
   end

   
   %% Solve for s = 0
   function schoolS = solve_s0(spS, h0)
      if isempty(h0)
         h0 = spS.h0;
      end
      
      % OJT problem when s = 0
      schoolS.s = 0;
      schoolS.hS = h0;

      % Marginal value of h(0)
      schoolS.q0 = spS.cvS.marginal_value_h(schoolS.hS, spS.T);
      schoolS.qS = schoolS.q0;

      % xS from first order condition at age 0
      schoolS.xS = spS.x_age(schoolS.s, schoolS.q0, h0);
   end   
   

   %% Value function, given solution
   %{
   IN
      schoolS
         solution
   
   OUT
      present value of lifetime earnings, net of xs
      discounted to start of schooling
   %}
   function [value, pvXs, pvEarn] = value_fct(spS, schoolS)
      pvEarn = exp(-spS.r .* schoolS.s) .* spS.cvS.value(schoolS.hS, spS.T - schoolS.s);

      % Present value of xs
      if schoolS.s > 0
         gx = spS.g_xs;
         pvXs = spS.pS .* schoolS.xS .* exp(-gx .* schoolS.s) ./ (gx - spS.r) .* ...
            (exp((gx - spS.r) * schoolS.s) - 1);
      else
         pvXs = 0;
      end

      value = -pvXs + pvEarn;
      validateattributes(value, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'scalar'})
   end   


end
   
end