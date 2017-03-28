function [meanLV, varLV] = truncated_normal(muL, sigmaL, lbV, ubV, dbg)
% Return mean and variance of truncated normal
%{
IN:
  muL, sigmaL
      mean and std dev of the normal to be truncated
  lb, ub
     Interval of truncation
     lb or ub can be empty for one-sided truncation

Fails when cdf = 1 at lower or upper bound. Then the output simply cannot be computed.

No problem to set lb or ub to []
% Source: wikipedia entry
%}


%% Input check
if dbg > 10
   validateattributes(muL, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'scalar'})
   validateattributes(sigmaL, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'scalar', 'positive'})
   if ~isempty(lbV)
      validateattributes(lbV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real'})
   end
   if ~isempty(ubV)
      validateattributes(ubV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real'})
   end
end


%% Main

if ~isempty(lbV)
   normLbV = (lbV - muL) ./ sigmaL;
   pdf1V = normpdf(normLbV, 0, 1);
   cdf1V = normcdf(lbV, muL, sigmaL);
end


if ~isempty(ubV)
   normUbV = (ubV - muL) ./ sigmaL;
   pdf2V = normpdf(normUbV, 0, 1);
   cdf2V = normcdf(ubV, muL, sigmaL);
end


if isempty(lbV)  &&  isempty(ubV)
   meanLV = muL;
   varLV  = sigmaL .^ 2;


elseif isempty(lbV)
   % One sided truncation: X < ub
   lambdaV = pdf2V ./ cdf2V;
   meanLV = muL - sigmaL .* lambdaV;
   varLV  = (sigmaL .^ 2) .* (1 - normUbV .* lambdaV - lambdaV .^ 2);


elseif isempty(ubV)
   % One sided truncation: X > lb
   lambdaV = pdf1V ./ (1 - cdf1V);
   %delta  = lambda .* (lambda - normLb);

   meanLV = muL + sigmaL .* lambdaV;
   varLV  = (sigmaL .^ 2) .* (1 + normLbV .* lambdaV - lambdaV .^ 2);

else
   % Two sided truncation
   meanLV = muL - sigmaL .* (pdf1V - pdf2V)  ./  (cdf1V - cdf2V);

   term1 = (normUbV .* pdf2V - normLbV .* pdf1V) ./ (cdf2V - cdf1V);
   term2 = (pdf2V - pdf1V) ./ (cdf2V - cdf1V);
   varLV  = (sigmaL .^ 2) .* (1 - term1 - term2 .^ 2);
end


%% Output check

validateattributes(varLV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive'})
validateattributes(meanLV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real'})

end