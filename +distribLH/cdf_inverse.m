function pctV = cdf_inverse(dataV, pointV, dbg)
% Inverse cdf of the unweighted data in dataV
%{
Repeated observations: add a tiny amount of noise

IN
   dataV  ::  double
      vector of data
   pointV  ::  double
      data points to look up

OUT
   pctV  ::  double
      percentile position of each point in the cdf
%}

n = length(dataV(:));

xV = sort(dataV(:));

if all(diff(xV) > eps)
   % Values are unique
   pctV = interp1(xV,  linspace(1/n, 1, n)',  pointV(:));
else
   % Need to add "noise"
   pctV = interp1(xV + (1 : n)' .* (5 * eps),  linspace(1/n, 1, n)',  pointV(:));
end

end