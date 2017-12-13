function xV = cdf(dataV, pctV, dbg)
% Points on cdf of the unweighted data in dataV
%{
Interpolates between data points

IN
   dataV  ::  double
      vector of data
   pctV  ::  double
      percentile points desired

   xV  ::  double
      pctV(i1) observations in dataV are <= xV(i1)
      out of range produces NaN
%}

if dbg > 10
   validateattributes(pctV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive', '<=', 1})
end

n = length(dataV);
xV = interp1(linspace(1/n, 1, n),  sort(dataV),  pctV);

end