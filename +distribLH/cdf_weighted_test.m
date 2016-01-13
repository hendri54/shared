function cdf_weighted_test
% -----------------------------------------

disp('Test cdf_weighted');
dbg = 111;
rng(32);

n = 1e2;

xInV = linspace(0, 1, n)';
wtInV = 1 + rand(n, 1);

idxV = randperm(n);

[cumPctV, xV, cumTotalV] = distribLH.cdf_weighted(xInV(idxV), wtInV(idxV), dbg);

% Compare
checkLH.approx_equal(cumPctV,  cumsum(wtInV) ./ sum(wtInV), 1e-3, []);
checkLH.approx_equal(xV, xInV, 1e-6, []);


end