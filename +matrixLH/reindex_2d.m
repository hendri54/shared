function outM = reindex_2d(inM, xV, yV, xTgV, yTgV)
% Given a matrix indexed by [xV, yV], make a matrix indexed by [xTgV, yTgV]
%{
Purpose is to make matrix into common shape

Indices in xTgV, yTgV but not in xV, yV: NaN
Indices in [xV, yV] but not in [xTgV, yTgV]: dropped

IN
   inM  ::  matrix
   xV, yV  ::  integer
%}

%% Input check

assert(isequal(length(unique(xV)), length(xV)));
assert(isequal(length(unique(yV)), length(yV)));
assert(isequal(length(unique(xTgV)), length(xTgV)));
assert(isequal(length(unique(yTgV)), length(yTgV)));


%% Main

% Convert xV and yV into indices
[xFoundV, xIdxV] = ismember(xV, xTgV);
[yFoundV, yIdxV] = ismember(yV, yTgV);

nx = length(xTgV);
ny = length(yTgV);
outM = nan(nx, ny);
if any(xFoundV)  &&  any(yFoundV)
   outM(xIdxV(xFoundV), yIdxV(yFoundV)) = inM(xFoundV, yFoundV);
end


%% Output check

assert(isequal(size(outM),  [nx, ny]));

end