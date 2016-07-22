% Continuation value for BenPorathCornerLH
%{
Takes a BenPorathContTimeLH object
Wraps it so that the right methods for a continuation value are available

Must be efficient
%}
classdef BenPorathCornerContValueLH
   
properties
   bpS   BenPorathContTimeLH
end

methods
   %% Constructor
   function cvS = BenPorathCornerContValueLH(bpS)
      cvS.bpS = bpS;
   end
   
   %% Value(h, T)
   function valueV = value(cvS, hV, TV)
      n = length(hV);
      valueV = zeros(size(hV));
      for i1 = 1 : n
         cvS.bpS.h0 = hV(i1);
         cvS.bpS.T  = TV(i1);
         valueV(i1) = cvS.bpS.pv_earnings;
      end
      validateattributes(valueV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive'})
   end
   
   
   %% dV/dh
   function mValueV = marginal_value_h(cvS, hV, TV)
      n = length(hV);
      mValueV = zeros(size(hV));
      for i1 = 1 : n
         cvS.bpS.h0 = hV(i1);
         cvS.bpS.T  = TV(i1);
         mValueV(i1) = cvS.bpS.marginal_value_h(0);
      end
      validateattributes(mValueV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive'})
   end
   
   
   %% dV/dT
   function mValueV = marginal_value_t(cvS, hV, TV)
      n = length(hV);
      mValueV = zeros(size(hV));
      for i1 = 1 : n
         cvS.bpS.h0 = hV(i1);
         cvS.bpS.T  = TV(i1);
         mValueV(i1) = cvS.bpS.marginal_value_T;
      end
      validateattributes(mValueV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive'})
   end
   
   
   %% Value of postponing: -rV + dV/dT
   function mValueV = value_postpone(cvS, hV, TV)
      n = length(hV);
      mValueV = zeros(size(hV));
      for i1 = 1 : n
         cvS.bpS.h0 = hV(i1);
         cvS.bpS.T  = TV(i1);
         mValueV(i1) = cvS.bpS.marginal_value_age0;
      end
      validateattributes(mValueV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', '<', 0})
   end
   
   
   %% Study time at start of OJT
   % To figure out whether a given (h, T) combination produces an (admissible) 
   % interior solution
   function n0V = study_time(cvS, hV, TV)
      n = length(hV);
      n0V = zeros(size(hV));
      for i1 = 1 : n
         cvS.bpS.h0 = hV(i1);
         cvS.bpS.T  = TV(i1);
         n0V(i1) = cvS.bpS.nh(0) ./ hV(i1);
      end      
      validateattributes(n0V, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive'})
   end
   
   
   %% Age profiles
   function [hV, nV, xV, qV, incomeV] = age_profiles(cvS, h0, T, ageV)
      cvS.bpS.h0 = h0;
      cvS.bpS.T  = T;
      validateattributes(ageV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', '>=', 0, '<=', T})
%       [hV, nV] = cvS.bpS.h_age(ageV);
%       xV = cvS.bpS.x_age(ageV);
      qV = cvS.bpS.marginal_value_h(ageV);
      [incomeV, hV, nV, xV] = cvS.bpS.age_earnings_profile(ageV);
   end
   
   
end
   
end