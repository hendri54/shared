% Piecewise linear function
%{
Currently only works for x >= 0
%}
classdef PiecewiseLinear < handle
   
properties
   % Interval cutoffs (upper bound of first to lower bound of last)
   cutoffV  double
   % Slopes
   slopeV  double
   intercept  double
end

methods
   %% Constructor
   function tS = PiecewiseLinear(slopeV, cutoffV, intercept)
      tS.slopeV = slopeV;
      tS.cutoffV = cutoffV;
      tS.intercept = intercept;
      tS.validate;
   end
   
   function validate(tS)
      assert(isequal(length(tS.slopeV),  1 + length(tS.cutoffV)));
      validateattributes(tS.cutoffV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'increasing', 'positive'})
      validateattributes(tS.intercept, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'scalar'})
   end
   
   
   %% Function value
   function yV = value(tS, xV)
      validateattributes(xV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', '>=', 0})
      
      % Upper bounds of intervals
      ubV = [tS.cutoffV; max(tS.cutoffV(end), max(xV)) + 1];
      n = length(tS.slopeV);
      
      yV = tS.intercept + tS.slopeV(1) .* min(xV, ubV(1));
      for i1 = 2 : n
         yV = yV + tS.slopeV(i1) .* max(0, min(ubV(i1), xV) - ubV(i1-1));
      end
      
      validateattributes(yV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'size', size(xV)})
   end
   
   
   %% Slopes
   function outV = slope(tS, xV)
      % Edges of intervals
      edgeV = [min(min(xV), tS.cutoffV(1) - 1);  tS.cutoffV; max(tS.cutoffV(end), max(xV)) + 1];
      outV = tS.slopeV(discretize(xV, edgeV));
      validateattributes(outV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'size', size(xV)})
   end
   
end
   
end