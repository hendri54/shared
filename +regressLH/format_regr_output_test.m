function format_regr_output_test

disp('Testing format_regr_output');

dbg = 111;
rng(23);

nObs = 55;
nRegr = 4;

xM = randn(nObs, nRegr);
epsV = randn(nObs, 1);
betaV = randn(nRegr, 1);
yV = xM * betaV + epsV;

mdl = fitlm(xM, yV);

varNameV = {'(Intercept)',  'x1', 'x3'};
outS = regressLH.format_regr_output(mdl, varNameV, dbg);

varNameStr = 'x3';
idx = find(strcmp(mdl.CoefficientNames, varNameStr));
assert(isequal(length(idx), 1));
% Tolerance must be low b/c we are looking at conversion from formatted string
checkLH.approx_equal(mdl.Coefficients.Estimate(idx),  str2double(outS.betaV{3}),  1e-2, []);

end