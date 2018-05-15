function xUbV = cl_bounds_w(xIn, wtIn, pctUbV, dbg)
% Find upper bounds of percentile classes
%{
Given data xIn with weights wtIn, find largest observation with cumulative weight
below pctUbV

This is done by interpolation!

Example: x = [1 2] with equal weights
   pctUbV = 0.25 : 0.25 : 1
   xUbV = [0.5, 1, 1.5, 2]

IN
   xIn
      data matrix
   wtIn
      weight matrix; may be []
   pctUbV
      Upper bounds of percentile classes. In [0, 1]
      Top class may be omitted. It is automatically appended

OUT
   xUbV        
      x values corresponding to percentile upper bounds
      given in pctUbV. Interpolated.

%}


%% Input check

assert(nargin >= 3);
if nargin < 4
   dbg = false;
end
if dbg
   validateattributes(diff(pctUbV), {'double'}, {'finite', 'nonnan', 'nonempty', 'real', '>', 1e-8})
end


%% Main

% Remove top class, if present
if pctUbV(end) > 0.9999
   pctUbV = pctUbV(1 : (end-1));
end

% Construct cdf (i.e. sort xIn and wtIn)
[cumPctV, xV] = distribLH.cdf_weighted(xIn, wtIn, dbg);

% Interpolate
xUbV = interp1(cumPctV, xV, pctUbV, 'linear', 'extrap');

% Add the upper bound of the top class
% Cannot use xV(end) for this b/c observations at the top with
% zero weight would not be considered
xUbV = [xUbV(:); double(max(xIn(:)))];


%% Output check

nCl = length(pctUbV) + 1;
validateattributes(xUbV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'size', [nCl,1]})

end
