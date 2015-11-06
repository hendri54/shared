function gSum = geo_sum(x, t1, t2)
% x ^ t1 + ... + x ^ t2

% if t1 == 0
%    g1 = 1;
% else
%    g1 = x ^ t1;
% end

gSum = (x ^ (t2+1) - x ^ t1) / (x - 1);


end