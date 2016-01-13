function extend_linear_trend_test

disp('Testing extend_linear_trend');

rng(21);
T = 20;
g1 = 0.1;
g2 = -0.2;
inV = 1 + rand(T, 1);
dbg = 111;

T1 = 5;
inV(1 : (T1-1)) = NaN;
T2 = 14;
inV((T2+1) : T) = NaN;


outV = vectorLH.extend_linear_trend(inV, g1, g2, dbg);

idxV = find(~isnan(inV));
assert(isequal(outV(idxV),  inV(idxV)));

growthV = diff(outV);
if any(abs(growthV(1 : (T1-1)) - g1) > 1e-6)
   error('Invalid g1');
end
if any(abs(growthV(T2 : end) - g2) > 1e-6)
   error('Invalid g2');
end

end