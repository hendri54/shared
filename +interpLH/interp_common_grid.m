function [gridV, y_xfM] = interp_common_grid(varargin)
% Given several functions given as points on grids
% return all functions as interpolations on the same grid (the union of the grids)
%{
Example: given 2 cdfs, put them on a common grid, so one can find crossing points

If grids differ in width, each function is interpolated in bounds of its own grid and has NaN
outside of those bounds

IN
   varargin  ::  cell
      each cell entry contains a 2d matrix with grid and function values
OUT
   gridV  :: double
      the common grid
   y_xfM  ::  double
      y(x, function)
%}

input_check(varargin{:});

nf = nargin;

if nf == 1
   fM = varargin{1};
   gridV = fM(:,1);
   y_xfM = fM(:,2);
   return;
end

gridV = concatenate_grids(varargin{:});
gridV = drop_duplicates(gridV);

y_xfM = zeros([length(gridV), nf]);
for i1 = 1 : nf
   fM = varargin{i1};
   y_xfM(:,i1) = interp1(fM(:,1), fM(:,2), gridV, 'linear');
end


end


function input_check(varargin)
   nf = nargin;
   for i1 = 1 : nf
      fM = varargin{i1};
      assert(isa(fM, 'double'));
      assert(size(fM, 2) == 2);
   end
end


function gridV = concatenate_grids(varargin)
   nf = nargin;
   gridV = [];
   
   for i1 = 1 : nf
      fM = varargin{i1};
      gridV = [gridV; fM(:,1)];
   end
end


function gridV = drop_duplicates(gridV)
   gMax = max(gridV);
   gMin = min(gridV);
   gridTol = max(1e-6,  (gMax - gMin) .* 1e-3);
   gridV = uniquetol(gridV, gridTol, 'DataScale', 1);
end