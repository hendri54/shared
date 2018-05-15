% Utility function of the type 
%     u(c) = a * (c ^(1-sigma) / (1-sigma) - 1)
%{
Assume multiple periods with discount factor beta
Nests log as special case (sigma = 1)

If there is a constant scaling utility, it simply multiplies u(c), u'(c) and lifetime utility.
%}
classdef UtilCrraLH
   
   properties
      % Curvature
      pSigma  double
      % Discount factor
      pBeta  double
      % Scale factor
      pFactor  double
   end
   
   
   
   methods 
      %% Constructor
      function uS = UtilCrraLH(pSigma, pBeta, pFactor)
         uS.pSigma = pSigma;
         uS.pBeta = pBeta;
         uS.pFactor = pFactor;
      end
      
      
      %% Utility of a stream
      %{
         c_itM
            consumption by [ind, date]
      %}
      function [util_itM, mu_itM] = util(uS, c_itM, dbg)
         mu_itM = [];
         computeMu = (nargout >= 2);
         
         if uS.pSigma == 1   
            % Log
            util_itM = log(c_itM) .* uS.pFactor;
            if computeMu
               mu_itM = uS.pFactor ./ c_itM;
            end
         else
            exp1 = 1 - uS.pSigma;
            util_itM = (c_itM .^ exp1  ./   exp1  - 1) .* uS.pFactor;
            if computeMu
               mu_itM = exp1 .* (util_itM + uS.pFactor) ./ c_itM;
            end
         end
         
         if dbg
            validateattributes(util_itM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', ...
               'size', size(c_itM)})
            if computeMu
               validateattributes(mu_itM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', ...
                  'positive', 'size', size(c_itM)})
            end
         end
      end
      
      
      %% Inverse marginal utility
      function c_itM = mu_inverse(uS, mu_itM, dbg)
         c_itM = (mu_itM ./ uS.pFactor) .^ (-1 ./ uS.pSigma);
         if dbg
            validateattributes(c_itM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive'})
         end
      end
      
      
      %% Lifetime utility
      function pvUtilV = lifetime_util(uS, c_itM, dbg)
         discRate = 1 / uS.pBeta - 1;
         pvUtilV = econLH.present_value(uS.util(c_itM, dbg), discRate, 1, dbg);
         if dbg
            nInd = size(c_itM, 1);
            validateattributes(pvUtilV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', ...
               'size', [nInd, 1]})
         end
      end
      
      
      %% Consumption growth rate for given R
      function cGrowth = c_growth(uS, R, dbg)
         cGrowth = (uS.pBeta * R) .^ (1 / uS.pSigma) - 1;
         if dbg
            if R < 0.5
               warning('Implausible R');
            end
         end
      end
      
      
      %% Present value of consumption, given constant interest rate
      function pvCons = pv_consumption(uS, c1, R, T, dbg)
         cGrowth = uS.c_growth(R, dbg);
         % PV(c) = c1 * sum of (cGrowth / R  .^ (0 : (T-1)))
         pvCons = c1 .* econLH.geo_sum((1 + cGrowth) ./ R,  0, T-1);
      end
      
      
      %% Given lifetime income and constant interest rate, solve for c(1)
      function c1 = age1_cons(uS, pvIncome, R, T, dbg)
         % Pv of consumption / c1
         pvFactor = uS.pv_consumption(1, R, T, dbg);
         c1 = pvIncome / pvFactor;
      end
      
      
      %% Lifetime utility for given c1 and constant R
      %{
      Note the scaling property: multiply c1 by X  =>  multiply U by X ^ (1-sigma)
         (or add log(X) for log utility)
      %}
      function pvUtilV = lifetime_util_c1(uS, c1V, R, T, dbg)
         cGrowth = 1 + uS.c_growth(R, dbg);
         if uS.pSigma == 1
            fac1 = econLH.geo_sum(uS.pBeta, 0, T-1);
            x1V = uS.pBeta .^ (0 : (T-1));
            x2V = 0 : (T-1);
            fac2 = log(cGrowth) .* sum(x1V .* x2V);
            pvUtilV = uS.pFactor .* (log(c1V) .* fac1  +  fac2);
         else
            fac1 = econLH.geo_sum((cGrowth .^ (1 - uS.pSigma)) * uS.pBeta, 0, T-1);
            fac2 = econLH.geo_sum(uS.pBeta, 0, T-1);
            u1V = c1V .^ (1 - uS.pSigma)  ./  (1 - uS.pSigma);
            pvUtilV = uS.pFactor .* (u1V .* fac1 - fac2);            
         end
         
         if dbg
            validateattributes(pvUtilV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', ...
               'size', size(c1V)})
         end
      end
      
   end
   
   
end