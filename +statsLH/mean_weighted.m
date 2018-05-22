function avg = mean_weighted(xM, wtM, dbg)
% Compute a weighted average
%{
IN
   xM  ::  numeric
      data
   wtM  ::  numeric
      weights, same size as xM
      must be >= 0

NaN inputs result in NaN output
Matrix inputs are flattened into vectors
Total weight = 0 results in NaN output
%}


%% Input check

if nargin < 3
   dbg = true;
end

if dbg
   assert(isequal(size(wtM), size(xM)),  'mean_weighted:SizeMismatch', 'Size mismatch');
   assert(all(wtM(:) >= 0),  'mean_weighted:NegativeWeights',  'Negative weights');
end


%% Main

validV = ~isnan(xM(:))  &  (wtM(:) > 0);
totalWeight = double(sum(wtM(validV)));
if totalWeight > 0
   avg = sum( double(xM(:)) .* double(wtM(:)) ) ./ totalWeight;
   if dbg
      validateattributes(avg, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'scalar'})
   end
else
   avg = NaN;
end



end