function pctV = pct_assign(xV, weightV, dbg)
% Returns percentile position of each observation
% First observation is assigned its weight. Last obs
% is assigned 1
%{
For unweighted data, this is very similar to the built in QUANTILE command
WeightedDataLH has similar functionality

IN:
   weightV  ::  double
      weights
      may be [], then assume unweighted
      zero weights are OK; they are treated like obs with positive weights

OUT
   pctV  ::  double
      fraction of observations with xV <= xV(i1)
%}

%if nargin < 3
%   dbg = 1;
%end

n = length(xV);
pctV = zeros([n, 1]);

if isempty(weightV)
   % Unweighted data
   [~, idxV] = sort(xV);
   pctV(idxV) = linspace(1/n, 1, n);
%    pctV(idxV(n)) = 1;
   
else
   m = sortrows([xV(:), weightV(:)./sum(weightV), (1:n)']);
   pctV(m(:,3)) = cumsum(m(:,2));
   pctV(m(n,3)) = 1;
end

if dbg
   validateattributes(pctV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive', '<=', 1})
   assert(max(pctV) == 1);
end

end 
