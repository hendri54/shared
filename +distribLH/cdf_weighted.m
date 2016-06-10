function  [cumPctV, xSortV, cumTotalV] = cdf_weighted(xIn, wtIn, dbg)
% CDF for weighted data
%{
Returns the cdf for weighted data
Given n observations with values xIn and weights wtIn

Observations with zero weights (really weights < 1e-10) are dropped

cumPctV(1) is the wtIn of the smallest value
xSortV(1) is the smallest value
xSortV(i) is the i-th smallest value
cumPctV(i) is the cumulative weight of the i smallest values

IN:
   xIn     
      matrix of values
   wtIn
      matrix of weights for x-values
      Maybe scalar for unweighted data (or [])

OUT:   (column vectors)
 cumPctV
    Cumulative weights. 0 to 1
 xSortV
    Values for cumulative weights
    Really just sorted xIn
 cumTotalV
    Cumulative total values (mass * x)
    Where total mass is normalized to 1.

AUTHOR: Lutz Hendricks
%}

isWeighted = (length(wtIn) > 1);

if isWeighted
   % Drop small weights
   idxV = find(wtIn > 1e-10);
   n = length(idxV);
   assert(n > 1);
   % Need to allocate these b/c I need to make them col vectors below
   wt = double(wtIn(idxV));
   x  = double(xIn(idxV));
   % Sort observations by x
   tmp = sortrows([x(:), wt(:)], 1);
   % cumulative weights
   cumPctV = cumsum(tmp(:,2));
   %totalMass = cumPctV(end);
   % Scale so that weights sum to 1
   cumPctV = cumPctV ./ cumPctV(end);
   cumPctV(end) = 1;
   
else
   tmp = sort(double(xIn(:)));
   n = length(tmp);
   %totalMass = n;
   cumPctV = (1/n : 1/n : 1)';
end



%%  Optional outputs


xSortV = tmp(:,1);

% Cumulative totals (mass normalized to 1)
if nargout > 2
   if isWeighted
      cumTotalV = cumsum(cumPctV .* xSortV);
   else
      cumTotalV = cumsum(xSortV) ./ length(xSortV);
   end
else
   cumTotalV = [];
end


%% Output check
if dbg > 10
   validateattributes(cumPctV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', '>=', 0, ...
      '<=', 1, 'size', [n, 1], 'increasing'})
   validateattributes(xSortV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', ...
      'size', [n, 1], 'nondecreasing'})
end

end 
