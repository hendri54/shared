classdef NormalDistribution < handle
      
properties
   dbg  uint16 = 1
end

methods
   %% Constructor
   function nS = NormalDistribution
   end
   
   
   %% Prob(x <= ubV) where each x has its own mean and std
   %{
   IN
      ubV :: double
         points on cdf; levels, NOT percentiles
      meanV, stdV
         for each distribution, mean and std
         x(j) ~ N(meanV(j), stdV(j))
   OUT
      probM  ::  double
         probM(j, k) = Prob(x(j) <= ubV(k))
   %}
   function probM = cdf(nS, ubV, meanV, stdV)
      nj = length(meanV);
      nk = length(ubV);
      probM = normcdf((repmat(ubV(:)', [nj, 1]) - repmat(meanV(:), [1, nk])) ./ repmat(stdV(:), [1, nk]));
      
      if nS.dbg
         validateattributes(probM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', '>=', 0, '<=', 1, ...
            'size', [nj, nk]})
      end
   end
   
   
   %% Prob(lbV < x <= ubV) where each x has its own mean and std
   %{
   IN
      ubV :: double
         points on cdf; levels, NOT percentiles
      meanV, stdV
         for each distribution, mean and std
         x(j) ~ N(meanV(j), stdV(j))
   OUT
      probM  ::  double
         probM(j, k) = Prob(ubV(k-1) < x(j) <= ubV(k))
         lowest interval is open to the left
   %}
   function probM = range_probs(nS, ubV, meanV, stdV)
      % Prob(x <= ubV)
      probM = nS.cdf(ubV, meanV, stdV);
      probM = [probM(:,1), diff(probM, 1, 2)];
      
      if nS.dbg
         nj = length(meanV);
         nk = length(ubV);
         validateattributes(probM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', '>=', 0, '<=', 1, ...
            'size', [nj, nk]})
      end
   end
end
   
end
