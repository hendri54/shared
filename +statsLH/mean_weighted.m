function avg = mean_weighted(xM, wtM, dbg)
% Compute a weighted average
%{
IN
   xM  ::  numeric
      data
   wtM  ::  numeric
      weights, same size as xM

NaN inputs result in NaN output
Total weight = 0 results in NaN output
%}


%% Input check

if nargin < 3
   dbg = 1;
end

if dbg > 5
   assert(isequal(size(wtM), size(xM)),  'Size mismatch');
   assert(all(wtM(:) >= 0),  'Negative weights');
end


%% Main

totalWeight = double(sum(wtM(:)));
if totalWeight > 0
   avg = sum( double(xM(:)) .* double(wtM(:)) ) ./ totalWeight;
   if dbg > 5
      validateattributes(avg, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'scalar'})
   end
   
else
   avg = NaN;
end



end