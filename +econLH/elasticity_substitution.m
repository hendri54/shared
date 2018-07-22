% Elasticity of substitution
%{
Computes elasticities numerically by perturbing input ratios

For some production functions, it does not matter to stay on the same isoquant (Cobb-Douglas, CES;
see unit testing). For others it does (nested CES)

Fails for nested CES. Reason not known

IN
   mp_fct  ::  function
      mp_fct(xV) gives marginal products
   xV  ::  double
      input vector
   i1V, i2V  ::  integer
      compute elasticity between inputs in i1V and those in i2V
OUT
   elastV  :: double
      returns NaN when i1 == i2
%}
function elastM = elasticity_substitution(mp_fct, xV, i1V, i2V)
   mpV = mp_fct(xV);
   
   n1 = length(i1V);
   n2 = length(i2V);
   elastM = zeros(n1, n2);
   
   % Loop over first input
   for k1 = 1 : n1
      i1 = i1V(k1);
    
      if true
         elastM(k1,:) = inner_stay_on_isoquant(mp_fct, xV, mpV, i1, i2V);
      else
         elastM(k1,:) = inner_not_on_isoquant(mp_fct, xV, mpV, i1, i2V);
       end

      % Will have NaN here, so I cannot assert all > 0
      if any(elastM(k1,:) < 0)
         error('Negative elasticities: %f', min(elastM(k1,:), [], 2, 'omitnan'));
      end
      elastM(k1, i2V == i1) = NaN;
   end
   
   
%    logMpV = log(mpV);
%    logXV = log(xV);
%    elastV = -exp(logMpV(i1) - logMpV(i2V) - logXV(i1) + logXV(i2V) - log(dMpRatio) + log(dXratio));
end



%% Without staying on same isoquant
% Much faster and cheaper
function elastV = inner_not_on_isoquant(mp_fct, xV, mpV, i1, i2V)
   dx = 1e-5;
   x2V = xV;
   x2V(i1) = xV(i1) + dx;
   mp2V = mp_fct(x2V);

   dXratioV = x2V(i1) ./ x2V(i2V) - xV(i1) ./ xV(i2V);
   dMpRatioV = (mp2V(i1) ./ mp2V(i2V)) - mpV(i1) ./ mpV(i2V);
   % Attempt to avoid numerical issues
   ratioV = dXratioV ./ dMpRatioV;

   elastV = -(mpV(i1) ./ mpV(i2V)) ./ (xV(i1) ./ xV(i2V)) .* ratioV;

   %       dRatioV = log(x2V(i1) ./ x2V(i2V)) - log(xV(i1) ./ xV(i2V));
   %       dMpV = log(mp2V(i1) ./ mp2V(i2V)) - log(mpV(i1) ./ mpV(i2V));
   %       elastM(k1,:) = -dRatioV ./ dMpV;
end


%% Stay on same isoquant
% Can only change one input at a time; hence expensive
% Does not seem to matter
function elastV = inner_stay_on_isoquant(mp_fct, xV, mpV, i1, i2V)
   dx = 1e-5;
   x2V = xV;
   x2V(i1) = xV(i1) + dx;

   n2 = length(i2V);
   elastV = zeros(1, n2);
   
   % Skip the diagonal element
   for k2 = find(i2V ~= i1)
      i2 = i2V(k2);

      dx2 = dx .* mpV(i1) ./ mpV(i2);
      x2V(i2) = xV(i2) - min(1e-4, max(1e-6, dx2));

      mp2V = mp_fct(x2V);
      
      dXratio = x2V(i1) ./ x2V(i2) - xV(i1) ./ xV(i2);
      dMpRatio = (mp2V(i1) ./ mp2V(i2)) - mpV(i1) ./ mpV(i2);
      % Attempt to avoid numerical issues
      ratioV = dXratio ./ dMpRatio;

      elastV(k2) = -(mpV(i1) ./ mpV(i2)) ./ (xV(i1) ./ xV(i2)) .* ratioV;
   end

end