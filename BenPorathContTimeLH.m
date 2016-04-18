%{
Continuous time Ben-Porath model. Based on Manuelli-Seshadri (AER 2014)

max present value of
   w * h(a) * (1 - n(a)) - px * x(a)
subject to
   h(0) given
   \dot(h) = A (h * n) ^ alpha * x ^ beta - deltaH * h
%}
classdef BenPorathContTimeLH < handle
   
properties
   A  double
   deltaH double
   gamma1 double
   gamma2  double
   px    double
   % Annual interest rate
   r     double
   wage  double
   % length of work life
   T     double
   h0    double
end

properties (Dependent)
   % gamma1 + gamma2
   gamma
   % Optimal x / nh when n is interior
   % From static FOC
   x2nh
end

methods
   %% Constructor
   function bpS = BenPorathContTimeLH(A, deltaH, gamma1, gamma2, T, h0, px, r, wage)
      bpS.A = A;
      bpS.deltaH = deltaH;
      bpS.gamma1 = gamma1;
      bpS.gamma2 = gamma2;
      bpS.px = px;
      bpS.r = r;
      bpS.wage = wage;
      bpS.T = T;
      bpS.h0 = h0;
      bpS.validate;
   end
   
   %% Validation
   function validate(bpS)
      validateattributes(bpS.A, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'scalar', 'positive'})
      validateattributes(bpS.deltaH, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'scalar', ...
         '>=', 0, '<', 1})
      validateattributes(bpS.gamma1, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'scalar', 'positive', '<', 1})
      validateattributes(bpS.gamma2, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'scalar', 'positive', '<', 1})
      assert(bpS.gamma1 + bpS.gamma2 < 0.99);
      validateattributes(bpS.px, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'scalar', 'positive'})
      validateattributes(bpS.r, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'scalar', '>=', 0, '<', 1})
      validateattributes(bpS.T, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'scalar', 'positive'})
   end
   
   function gma = get.gamma(bpS)
      gma = bpS.gamma1 + bpS.gamma2;
   end
   
   function xOverNh = get.x2nh(bpS)
      xOverNh = bpS.wage / bpS.px * bpS.gamma2 / bpS.gamma1;
   end
   
   % Term in brackets in many equations
   function out1 = bracket_term(bpS)
      out1 = bpS.A * bpS.gamma1 / (bpS.r + bpS.deltaH) * ((bpS.gamma2 / bpS.gamma1 * bpS.wage ./ bpS.px) ^ bpS.gamma2);
   end
   
   % Marginal value of h. Only depends on horizon remaining, not on current h
   % (20) in MS 2014
   function q_aV = marginal_value_h(bpS, ageV)
      q_aV = bpS.wage .* bpS.m_age(ageV) ./ (bpS.r + bpS.deltaH);
   end
   
   
   %% Marginal value of increasing starting age
   % -r V + dV/d(age0)
   %{
   This can be computed without integration (easier than computing the parts separately)
   Useful for optimal stopping rule that sets starting age (e.g. MS2014 school problem)
   %}
   function mValue = marginal_value_age0(bpS)
      C1 = (1 - bpS.gamma) ./ bpS.gamma1 .* (bpS.bracket_term .^ (1 ./ (1 - bpS.gamma)));
      mValue = bpS.wage .* bpS.h0 ./ (bpS.r + bpS.deltaH) .* (bpS.mprime_age(0) - bpS.r .* bpS.m_age(0)) ...
         - bpS.wage .* C1 .* (bpS.m_age(0) .^ (1 ./ (1 - bpS.gamma)));
      validateattributes(mValue, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'scalar'})
   end
      
% dV/d(age0)   
%       C1 = bpS.h0 .* bpS.mprime_age(0) ./ (bpS.r + bpS.deltaH);
%       C2 = -(bpS.m_age(0) .^ (1 ./ (1 - bpS.gamma)));
%       C3 = integral(@mva_nested, 0, bpS.T);
% 
%       mValue = bpS.wage .* (C1 + (1 - bpS.gamma) ./ bpS.gamma1 .* (bpS.bracket_term .^ (1 ./ (1 - bpS.gamma))) .* ...
%          (C2 + bpS.r .* C3));
%       validateattributes(mValue, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'scalar'})
%       
%       % Nested: integrand
%       function outV = mva_nested(tV)
%          outV = exp(- bpS.r .* tV) .* (bpS.m_age(tV) .^ (1 ./ (1 - bpS.gamma)));
%       end
%    end
   
   %% Marginal value of T
   function mValue = marginal_value_T(bpS)
      mValue = bpS.wage .* bpS.h0 ./ (bpS.r + bpS.deltaH) .* bpS.dm_dT(0)  +  ...
         bpS.wage .* (1 - bpS.gamma) ./ bpS.gamma1 .* (bpS.bracket_term .^ (1 ./ (1-bpS.gamma))) .* ...
         integral(@integ_mv, 0, bpS.T);
      validateattributes(mValue, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'scalar'})
      
      % Nested: integrand
      function outV = integ_mv(tV)
         outV = exp(-bpS.r .* tV) .* (bpS.m_age(tV) .^ (bpS.gamma ./ (1 - bpS.gamma))) .* ...
            bpS.dm_dT(tV) ./ (1 - bpS.gamma);
      end
   end
   
   
   %% Technology: hDot as a function of h,n,x
   function hDotV = htech(bpS, hV, nV, xV)
      hDotV = bpS.A .* ((hV .* nV) .^ bpS.gamma1) .* (xV .^ bpS.gamma2) - bpS.deltaH .* hV;
   end
   
   
   %% Age earnings profile
   function earnV = age_earnings_profile(bpS, ageV)
      xwV = bpS.x_age(ageV);
      [haV, naV] = bpS.h_age(ageV);
      earnV = bpS.wage .* haV .* (1 - naV) - bpS.px .* xwV;
      validateattributes(earnV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'size', size(ageV)})
   end
   
   
   %% Present value of lifetime earnings
   % Value function V(h,T)
   % MS 2014 have a closed form solution
   function pvEarn = pv_earnings(bpS)
      pvEarn = integral(@integ_pv, 0, bpS.T);
      validateattributes(pvEarn, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'scalar'})
   
      % Nested: integrand
      % returns present value of earnings at given ages
      function outV = integ_pv(ageV)
         outV = exp(-bpS.r .* ageV) .* bpS.age_earnings_profile(ageV);
      end
   end
   
   
   %% n(a) h(a) from (17)
   %{
   This agrees with MS
   Can be used to determine whether hh chooses n<1 at age 0
   %}
   function [nhV, xV] = nh(bpS, ageV)
      %c1  = bpS.A .* (bpS.gamma1 .^ (1 - bpS.gamma2)) .* (bpS.gamma2 .^ bpS.gamma2) ./ (bpS.r + bpS.deltaH);
      %c2  = (bpS.wage ./ bpS.px) .^ bpS.gamma2;
      maV = bpS.m_age(ageV);

      nhV  = (bpS.bracket_term .* maV)  .^ (1 / (1-bpS.gamma));
      validateattributes(nhV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', ...
         '>=', 0, 'size', size(ageV)})
      
      % Static condition recovers x
      xV   = nhV .* bpS.x2nh;
      validateattributes(xV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', '>=', 0})
   end


   %% x(a) from (18)
   % this is where MS2014 have a mistake
   % Easier to get this from nh()
   function xwV = x_age(bpS, ageV)
      c1 = bpS.gamma2 / bpS.gamma1 * bpS.wage ./ bpS.px;
      %c2 = bpS.A * bpS.gamma1 / (bpS.r + bpS.deltaH) * ((bpS.gamma2 / bpS.gamma1 * bpS.wage ./ bpS.px) ^ bpS.gamma2);
      
      maV = bpS.m_age(ageV);

      xwV = c1 .* ((bpS.bracket_term .* maV) .^ (1 / (1-bpS.gamma)));
      validateattributes(xwV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', ...
         '>=', 0, 'size', size(ageV)})
   end


   %% h(a) from (19)
   function [haV, naV] = h_age(bpS, ageV)
      % c2 from the x(a) equation
      % c2 = bpS.A * bpS.gamma1 / (bpS.r + bpS.deltaH) * ((bpS.gamma2 / bpS.gamma1 * bpS.wage ./ bpS.px) ^ bpS.gamma2);
      c2 = bpS.bracket_term;

      c3V = zeros(size(ageV));
      for i1 = 1 : length(ageV)
         age = ageV(i1);
         c3V(i1) = integral(@c3_integrand,  0,  ageV(i1));
      end
      validateattributes(c3V, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', ...
         '>=', 0, 'size', size(ageV)})

      haV = exp(-bpS.deltaH .* ageV) .* bpS.h0  +  ...
         (bpS.r + bpS.deltaH) ./ bpS.gamma1 .* (c2 .^ (1 / (1 - bpS.gamma))) .* c3V;
      validateattributes(haV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', ...
         '>', 0, 'size', size(ageV)})

      naV = bpS.nh(ageV) ./ haV;
      validateattributes(naV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', ...
         '>=', 0, 'size', size(ageV)})


         % Nested: integrand for c3
         function x = c3_integrand(tV)
            mtV = bpS.m_age(tV);
            x = exp(-bpS.deltaH .* (age - tV)) .* (mtV .^ (bpS.gamma / (1 - bpS.gamma)));
            validateattributes(x, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', ...
               '>=', 0})
         end
   end
   
     
   
   %% m(a)
   function maV = m_age(bpS, ageV)
      validateattributes(bpS.T - ageV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', '>=', 0})
      maV = 1 - exp((bpS.r + bpS.deltaH) .* (ageV - bpS.T));
      validateattributes(maV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'size', size(ageV)})
   end
   
   % m'(a)
   function mPrimeV = mprime_age(bpS, ageV)
      mPrimeV = -(bpS.r + bpS.deltaH) .* exp((bpS.r + bpS.deltaH) .* (ageV - bpS.T));
   end
   
   % dm(a)/dT
   function dmdT = dm_dT(bpS, ageV)
      dmdT = (bpS.r + bpS.deltaH) .* exp((bpS.r + bpS.deltaH) .* (ageV - bpS.T));
   end
   
   
   %% Path h(a) for given inputs n(a), x(a); and h0
   %{
   The result is not super precise (see test function)
   
   IN
      ageV, naV, xaV
         on an age grid: inputs (will be interpolated)
      ageOut
         solve for h at this age
   
   OUT
      tOutV, hOutV
         values of h(t) between 0 and ageOut
   %}
   function [tOutV, hOutV] = hpath(bpS, ageOut, ageV, naV, xaV)
      if ageOut < 1e-6
         tOutV = ageOut;
         hOutV = bpS.h0;
         return;
      end
      
      % Make a smooth approximation to n(a) and x(a)
      nFct = griddedInterpolant(ageV, naV, 'linear');
      xFct = griddedInterpolant(ageV, xaV, 'linear');
      
      % Solve the ode
      % Integral of hDot between 0 and ageOut
      [tOutV, hOutV] = ode45(@(t,h)  bpS.htech(h, nFct(t), xFct(t)), [0, ageOut],  bpS.h0);
      validateattributes(hOutV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive'})
   end
   
   
end

end