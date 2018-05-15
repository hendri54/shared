function xClV = class_assign(xV, wtV, clUbV, dbg)
% Assign each value in a vector its percentile class position
%{
TASK:
 Given an input vector xV with weights wtV
 Sort all observations into classes so that the smallest xV are
 in class 1 and the largest xV are in class nc
 Return the class assignment for each xV

 If a class has 0 mass, that's allowed

This does not make sense for discrete, repeated values of x
Then there is no unique assignment of x to a percentile class

IN:
 xV
      matrices are flattened into vectors
 wtV         
      Need not sum to 1
      May be [] for unweighted data
clUbV       
      Vector of class upper bounds (between 0 and 1)
      Top class (<= 1) is not automatically attached. It is required
      The smallest clUbV(1) pct of the xV get xClV = 1 etc.

OUT:
   xClV(1:n)      
      Class assigment for each xV
      If not in any class: 0

AUTHOR: Lutz Hendricks, 1999
Checked: 2015-Feb-25

Was previously called just class_assign
%}


%% Input check

if nargin < 4
   dbg = true;
end
if nargin < 3
   error('Invalid nargin');
end

n  = numel(xV);
nc = length(clUbV);
clUbV = double(clUbV(:));

if max(clUbV) > 1
   if max(clUbV) - 1 < 1e-8
      % If rounding problem: fix it
      clUbV = min(1, clUbV);
   
   else
      % Otherwise: error
      error('Invalid class upper bounds');
   end
end


if dbg
   validateattributes(xV, {'numeric'}, {'finite', 'nonnan', 'nonempty', 'real'})
   validateattributes(clUbV(:), {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'size', [nc, 1], ...
      '>=', 0, '<=', 1})
   % Upper bounds must be increasing (weakly)
   if any(diff(clUbV) < -1e-10)
      error('clUbV must be increasing');
   end
   assert(clUbV(end) == 1);
end


% %%  Sort observations
% 
% if isempty(wtV)
%    % Unweighted data
%    %tmp = sortrows([double(xV(:)), (1:n)'], 1);
%    %sortIdxV = tmp(:,2)';            % Sorted indices
%    tmp = sort(double(xV(:)));
%    cumWtV = (1 : n)' ./ n;
% else
%    tmp = sortrows([double(xV(:)), double(wtV(:))], 1);
%    %tmp = sortrows([double(xV(:)), (1:n)', double(wtV(:))], 1);
%    %sortIdxV = tmp(:,2)';            % Sorted indices
%    cumWtV   = cumsum(tmp(:,2));      % Cumulative weights
%    cumWtV   = cumWtV(:) ./ cumWtV(end);
% end
% 
% cumWtV(end) = 1;
% 
% 

%% Alternative algorithm
% 
% % % Upper bounds for all classes
% % xUbV = repmat(tmp(1,1) - 1, [nc, 1]);
% % for ic = 1 : nc
% %    idx1 = find(cumWtV <= clUbV(ic), 'last');
% %    if ~isempty(idx1)
% %       xUbV(ic) = tmp(idx1) + 1e-10;
% %    else
% %       % Empty class
% %       xUbV(ic) = xUbV(ic - 1) + 1e-10;
% %    end
% % end
% 
% % Find class upper bounds by interpolating cumulative weights
% xUbV = interp1(cumWtV, tmp(:,1), clUbV, 'linear', 'extrap');

xUbV = distribLH.cl_bounds_w(double(xV(:)), double(wtV(:)), clUbV, dbg);
% For numerical reasons, push right edges up a bit
xClV = discretize(double(xV(:)), [min(xV(:))-1; xUbV + 1e-8], 'IncludedEdge', 'left');


%% Assign class to each obs

% xClV = zeros([n, 1]);
% clLbV = [-1; clUbV(1 : (nc-1))];
% for ic = 1 : nc
%    % Make sure we do not miss the top observations due to rounding
%    if ic == nc  &&  abs(clUbV(nc) - 1) < 1e-8
%       ub = 1.1;
%    else
%       ub = clUbV(ic);
%    end
%    % Find obs in this class
%    idxV = find(cumWtV >= clLbV(ic)  &  cumWtV <= ub);
%    if ~isempty(idxV)
%       xClV(sortIdxV(idxV)) = ic;
%    end
% end
% 
% assert(isequal(xCl2V, xClV));


%%  SELF-TEST
if dbg
   % Some may have class 0 (not in any bin)
   validateattributes(xClV, {'double'}, {'finite', 'nonnan', 'nonempty', 'integer', '>=', 0, ...
      '<=', nc,  'size', [n,1]})
end



end