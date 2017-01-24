function [xIdxV, xGridV] = grid_round_to(xV, gridV, dbg)
% Round data in xV to nearest grid points
%{
OUT:
   xGridV         xV rounded to grid points 
   xIdxV          xIdxV(i) is the grid index nearest xV(i)
%}

% Grid mid-points make up edges
ng = length(gridV);
midPointV = ( gridV(1:ng-1) + gridV(2:ng) ) ./ 2;

% Round: Grid midpoints are upper bounds of intervals
%  Assigns values above largest mid point to interval ng
xIdxV = discretize(xV,  [min(gridV(1), min(xV)) - 1; midPointV(:);  max(gridV(ng), max(xV)) + 1]);

if nargout > 1
   xGridV = gridV(xIdxV);
else
   xGridV = [];
end


% Output test
if dbg > 10
   validateattributes(xIdxV, {'double'}, {'finite', 'nonnan', 'nonempty', 'integer', 'positive', '<=', ng})
end

end