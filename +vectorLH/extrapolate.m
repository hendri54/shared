function outV = extrapolate(xV, dbg)
% Given a vector with missing values (NaN)
% Extrapolate at beginning and end
% Interpolate in the middle

if any(isnan(xV))
   nIdxV = find(~isnan(xV));
   if length(nIdxV) < 2
      error('Too many nan points');
   end
   outV = interp1(nIdxV, xV(nIdxV), (1 : length(xV))',  'linear', 'extrap');
else
   outV = xV;
end

if dbg > 10
   validateattributes(outV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'size', size(xV(:))})
end

end