function xM = randi(xMin, xMax, sizeV, dbg)
% Integer random draws with equal probs over a given range
%{
Permits range to be 1 value. 
%}

validateattributes(xMax, {'double'}, {'finite', 'nonnan', 'nonempty', 'scalar', 'integer', '>=', xMin})

if xMax == xMin
   xM = repmat(xMin, sizeV);
   
else
   xM = xMin - 1 + randi(xMax - xMin + 1, sizeV);
end

%% Output check
if dbg
   validateattributes(xM, {'double'}, {'finite', 'nonnan', 'nonempty', 'integer', '>=', xMin, '<=', xMax, ...
      'size', sizeV})
end

end