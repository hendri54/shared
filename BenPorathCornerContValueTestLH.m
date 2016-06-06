% Continuation value for BenPorathCornerLH
%{
For testing only. Use as template for the real thing
V(h,T) = (h ^ alpha) .* (1 - exp(-r T))
%}
classdef BenPorathCornerContValueTestLH
   
properties
   % Curvature
   alpha    double
   r  double
   mult  double
end

methods
   %% Constructor
   function cvS = BenPorathCornerContValueTestLH
      cvS.alpha = 0.6;
      cvS.r = 0.05;
      cvS.mult = 40;
   end
   
   %% Value(h, T)
   function valueV = value(cvS, hV, TV)
      valueV = cvS.mult .* (hV .^ cvS.alpha) .* (1 - exp(-cvS.r .* TV));
      validateattributes(valueV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive'})
   end
   
   
   %% dV/dh
   function mValueV = marginal_value_h(cvS, hV, TV)
      valueV = cvS.value(hV, TV);
      mValueV = cvS.alpha .* valueV ./ hV;
      validateattributes(mValueV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive'})
   end
   
   
   %% dV/dT
   function mValueV = marginal_value_t(cvS, hV, TV)
      mValueV = cvS.r .* cvS.mult .* (hV .^ cvS.alpha) .* exp(-cvS.r .* TV);
      validateattributes(mValueV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive'})
   end
   
   
   %% Value of postponing: -rV + dV/dT
   function mValueV = value_postpone(cvS, hV, TV)
      mValueV = -cvS.r .* cvS.value(hV, TV) - cvS.marginal_value_t(hV, TV);
      validateattributes(mValueV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', '<', 0})
   end
   
   
   %% Study time at start of OJT
   % To figure out whether a given (h, T) combination produces an (admissible) 
   % interior solution
   function n0V = study_time(cvS, hV, TV)
      n0V = (TV ./ hV ./ 10) .^ 0.5;
      validateattributes(n0V, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive'})
   end
   
   
end
   
end