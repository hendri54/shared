function r2 = rsquared(yV, yPredV, wtV, dbg)
% Compute R^2 for data yV and predicted values yPredV
%{
IN
   wtV
      weights for deviations, may be [] for unweighted data
%}

n = length(yV);
if isempty(wtV)
   wtV = ones(size(yV));
end


%% Input check
if dbg > 10
   validateattributes(yV(:),     {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'size', [n,1]})
   validateattributes(yPredV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'size', size(yV)})
   validateattributes(wtV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', '>=', 0, 'size', size(yV)})
end

wtSum = sum(wtV);
tss = sum(((yV - mean(yV)) .^ 2) .* wtV ./ wtSum);
rss = sum(((yV - yPredV) .^ 2)   .* wtV ./ wtSum);

r2 = 1 - rss / tss;

validateattributes(r2, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'scalar'})


end