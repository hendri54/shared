function [maxVal, idxV] = max(inM, omitNan)
% Return max value in a matrix and its indices

% Same as Matlab default
if nargin < 2
   omitNan = true;
end

if omitNan
   nanStr = 'omitnan';
else
   nanStr = 'includenan';
end

[maxVal, maxIdx] = max(inM(:), [], 1, nanStr);

idxV = matrixLH.ind2sub(size(inM), maxIdx);


end