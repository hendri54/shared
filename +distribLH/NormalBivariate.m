% Bivariate normal distribution
%{
There is also a MultiVarNormal class, but some results can only be computed for the bivariate
%}

classdef NormalBivariate
   
   
properties
   % Means
   meanV
   % Std deviations
   stdV
   % Correlation
   corr
end


properties (Dependent)
   % covariance matrix
   covM
end



methods
   %% Constructor
   function nbS = NormalBivariate(meanV, stdV, corr)
      nbS.meanV = meanV;
      nbS.stdV = stdV;
      nbS.corr = corr;
   end
   
   
   %% Cov matrix
   function covM = get.covM(nbS)
      % Covar matrix
      covar = nbS.corr .* prod(nbS.stdV);
      covM = [nbS.stdV(1) ^ 2,  covar;  covar,  nbS.stdV(2) ^ 2];
   end
   
   
   %% E(x1 | x2)
   % Source: Wikipedia
   function outV = cond_expect(nbS, x2V, dbg)
      outV = nbS.meanV(1) + nbS.corr .* nbS.stdV(1) ./ nbS.stdV(2) .* (x2V - nbS.meanV(2));

      if dbg
         validateattributes(outV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'size', size(x2V)})
      end
   end
   
   
   %% Var(x1 | x2)
   % Source: Wikipedia
   function out1 = cond_var(nbS)
      out1 = (1 - nbS.corr ^ 2) * (nbS.stdV(1) ^ 2);
   end
   
   
   %% Density x1 | x2
   % Source: Wikipedia. Simply normal with conditional mean and var
   function outV = cond_density(nbS, x1V, x2V, dbg)
      outV = normpdf(x1V,  nbS.cond_expect(x2V, dbg),  nbS.cond_var .^ 0.5);
      
      if dbg
         validateattributes(outV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'size', size(x1V)})
      end
   end
   
   
   %% density(x1 | x2 in interval)
   %{
   Source: NASA (http://www.nasa.gov/centers/dryden/pdf/87929main_H-1120.pdf)
   Assumes that variables are standardized!
   IN
      x2LbV, x2UbV
         interval bounds for each x1; may be scalar
   %}
%    function outV = cond_density_interval(nbS, x1V, x2LbV, x2UbV, dbg)
%       outV = normpdf(x1V) ./ (normcdf(x2UbV) - normcdf(x2LbV)) .* ...
%          (normcdf((x2UbV - nbS.corr .* x1V) ./ sqrt(1 - nbS.corr .^ 2)) - ...
%          normcdf((x2LbV - nbS.corr .* x1V) ./ sqrt(1 - nbS.corr .^ 2)));
%    end
   
   
   %% Expectation x1 | x2 in interval
   %{
   Numerically integrate E(x|y) f(y) / P(lb <= y <= ub)
   Can be NaN when bounds are in the tails
   
   IN
      x2LbV, x2UbV
         interval bounds for all points
   
   For unknown reason, the result is not precise when the interval is in the tails of the x2 distribution
      (integration problem?) +++
   %}
   function outV = cond_expect_interval(nbS, x2LbV, x2UbV, dbg)
      % Distribution of x2
      mean2 = nbS.meanV(2);
      var2 = nbS.stdV(2) ^ 2;

      outV = nan(size(x2LbV));
      for i1 = 1 : length(x2LbV)
         % Prob(x2 in interval)
         cdfV = normcdf([x2LbV(i1), x2UbV(i1)], mean2, var2);
         x2Mass = diff(cdfV);
         if x2Mass > 1e-8
            outV(i1) = integral(@integrand, x2LbV(i1), x2UbV(i1));
         end
      end
      
%       if dbg
%          validateattributes(outV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'size', size(x2LbV)})
%       end
      
      
      % *****  Nested: integrand, E(x1 | x2) * pdf(x2 | x2 in interval)
      function xOutV = integrand(x2V)
         xOutV = nbS.cond_expect(x2V, 0) .* normpdf(x2V, mean2, var2) ./ x2Mass;
         validateattributes(xOutV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real'})
      end
   end
end
   
   
end