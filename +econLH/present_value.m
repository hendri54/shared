function prValueV = present_value(xM, discRate, discDate, dbg)
% Compute present value of xM
%{
IN:
 xM
    Data by [ind, date]
 discRate
    Discount rate, e.g. 0.04
 discDate
    Date to discount to

OUT
   prValueV  ::  [nInd, 1]
%}

if nargin ~= 4
   error('Invalid nargin');
end

[nInd, T] = size(xM);

% This factor discounts date t to discDate
%  Multiply a figure by this factor
discFactorV = (1 + discRate) .^ (discDate - (1:T));

prValueV = sum(xM .* (ones(nInd,1) * discFactorV), 2);

if dbg > 10
   validateattributes(prValueV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', ...
      'size', [nInd, 1]})
end

end