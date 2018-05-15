function [md, mdIdx] = weighted_median(xV, wtV, dbg)
% Median for weighted data
%{
Largest xV with cumulative weight <= 0.5

Weights need not sum to one

IN:
 xV(n)       data
 wtV(n)      weights

OUT:
   md          
      median
   mdIdx
      index of median x

%}

if nargin < 3
   dbg = 1;
end

if dbg
   n = length(xV);
   validateattributes(xV(:),  {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'size', [n,1]})
   validateattributes(wtV(:), {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'size', [n,1], ...
      '>=', 0})
end


totalWt = sum(wtV);


% Fast implementation
%  Difference is not large, though
[~, wtIdxV] = sort(xV);
mIdx = find(cumsum(wtV(wtIdxV)) > 0.5 * totalWt, 1);
mdIdx = wtIdxV(mIdx-1);
md = xV(mdIdx);


% % Slower implementation
% sortM = sortrows([xV(:), wtV(:)], 1);

% Find 1st index entry
% idxV = find(cumsum(sortM(:, 2)) > 0.5 * totalWt, 1);
% md = sortM(idxV(1) - 1, 1);
% 
% if abs(md2 - md) > 1e-8
%    keyboard
%    error('Invalid');
% end

% Cannot use interp1 here (x may have duplicate values)
% md = intrp_1( cumsum(sortM(:,2)), sortM(:,1), 0.5, dbg );

if dbg
   validateattributes(md, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'scalar'})
end

end
