function [countV, midV] = hist_weighted(xV, wtV, binEdgesV, dbg)
% Histogram with weighted data
%{
Result can be shown as `bar(xV, wtV)`

Observations outside of binEdgesV are ignored

IN:
   xV
      data
   wtV
      weights
   binEdgesV
      edges of bins, starting with left edges of lowest

OUT:
 countV
    total weight in each bin
 midV
    bin mid points
%}


%%  Input check

if nargin ~= 4
   error('Invalid nargin');
end

% if min(xV) <= binEdgesV(1)  ||  max(xV) > binEdgesV(end)
%    error('xV must be within bins');
% end
if dbg > 10
   validateattributes(xV,  {'double'}, {'finite', 'nonnan', 'nonempty', 'real'})
   validateattributes(wtV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'size', size(xV)})
   validateattributes(binEdgesV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real'})
end


%%  Main

% 1 + no of bins
n = length(binEdgesV);

% Midpoints of bin edges
midV = 0.5 .* (binEdgesV(1:(n-1)) + binEdgesV(2:n));
midV = midV(:);

% % Assign each xV a bin
% %  Not all binV are assigned (out of bounds cases have 0)
% [~, binV] = histc(xV(:), binEdgesV(:));
% 
% % Undo the fact that histc assigns xV == binEdgesV(end) to its own bin (n+1)
% binV(xV == binEdgesV(end)) = n - 1;
% 
% validateattributes(binV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'integer', '<=', n - 1})
% 
% % Count weights in each bin
% % There can be zeros (including first bins)
% % If last bins empty: countV has no elements
% idxV = find(binV >= 1);
% countStartV = accumarray(binV(idxV), wtV(idxV));
% countV = zeros([n-1, 1]);
% countV(1 : length(countStartV)) = countStartV; 
% 


%% Alternative

binV = discretize(xV(:), binEdgesV(:), 'IncludedEdge', 'right');
nBins = length(binEdgesV) - 1;
countV = accumarray(binV(binV >= 1),  wtV(binV >= 1),  [nBins, 1],  @sum);

% assert(isequal(countV, count2V));   % +++++



% Add trailing (empty) bins, if necessary
% if nc < nEdges
%    countV = [countV(:); zeros([nEdges-nc, 1])];
%    midV   = [midV(:); zeros([nEdges-nc, 1])];
% end




end % eof