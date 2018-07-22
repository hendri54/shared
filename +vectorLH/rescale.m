function outV = rescale(inV, xMin, xMax, dbg)
% Rescale a vector so that it lies in [xMin, xMax]
%{
Preserve relative log differences
Vector must be > 0
%}

if dbg
   assert(all(inV > 0));
   assert(xMin > 0);
   assert(xMax > 0);
end

logInMin = log(min(inV));
logInMax = log(max(inV));

outV = exp((log(inV) - logInMin) .* (log(xMax) - log(xMin)) ./ (logInMax - logInMin)) .* xMin;

% Deal with numerical accuracy
outV = max(xMin, min(xMax, outV));

if dbg
   validateattributes(outV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', '>=', xMin, ...
      '<=', xMax, 'size', size(inV)})
end

end