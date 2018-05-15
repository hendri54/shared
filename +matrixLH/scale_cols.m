function outM = scale_cols(inM, lb, ub, missVal, dbg)
% Scale elements in a matrix to lie in [lb, ub]
% Keep the column total unchanged
%{
Example use:
Given a matrix of probabilities, bound the probabilities away from 0 and 1

Cannot guarantee that scaling works. If too many elements are capped, there may not be a way to
scale all elements to lie in bounds without changing sums.
In that case the sums do change

Columns that contain NaN or missVal are ignored
%}

%% Input check
if dbg
   validateattributes(lb, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'scalar'})
   validateattributes(ub, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'scalar', '>', lb})
   validateattributes(missVal, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'scalar'})
   assert(length(size(inM)) == 2);
end


%% Main

outM = inM;
[nr, nc] = size(inM);

% Find columns that need scaling
cIdxV = find((any(inM < lb) | any(inM > ub))  &  ~any(isnan(inM))  &  ~any(inM == missVal));
if ~isempty(cIdxV)
   % Loop over columns
   for ic = cIdxV(:)'
      xV = inM(:, ic);
      
      % Find elements that hit bounds
      lbIdxV = find(xV < lb);
      ubIdxV = find(xV > ub);
      intIdxV = 1 : nr;
      intIdxV([lbIdxV; ubIdxV]) = [];
      assert(~isempty(intIdxV));
      
      % Sum of interior elements
%       intSum = sum(xV(intIdxV));
      
      % Change in sum of clipped elements
      if ~isempty(lbIdxV)
         dLbSum = length(lbIdxV) * lb - sum(xV(lbIdxV));
%          xV(lbIdxV) = lb;
      else
         dLbSum = 0;
      end
      if ~isempty(ubIdxV)
         dUbSum = length(ubIdxV) * ub - sum(xV(ubIdxV));
%          xV(ubIdxV) = ub;
      else
         dUbSum = 0;
      end
      
      % Scale interior elements
      xV(intIdxV) = xV(intIdxV) - (dLbSum + dUbSum) ./ length(intIdxV);
      outM(:, ic) = max(lb, min(ub, xV));
   end
end


%% Output check
if dbg
   validateattributes(outM(~isnan(inM)), {'double'}, {'finite', 'nonnan', 'nonempty', 'real'})
%    cSum3V = sum(outM(:, cIdxV));
%    cSumV  = sum(inM(:, cIdxV));
%    checkLH.approx_equal(cSum3V, cSumV, 1e-6, []);
   if ~isempty(cIdxV)
      validateattributes(outM(:, cIdxV), {'double'}, {'finite', 'nonnan', 'nonempty', 'real', '>', lb - 1e-8, ...
         '<', ub + 1e-8})
   end
end


end