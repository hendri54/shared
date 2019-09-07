function tests = format_regr_output_test

tests = functiontests(localfunctions);

end


function oneTest(testCase)

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

varNameV = ["(Intercept)",  "x_1", "x3"];
outS = regressLH.format_regr_output(mdl, varNameV, dbg);


% Test recovery of coefficient
varNameStr = 'x3';
idx = find(strcmp(mdl.CoefficientNames, varNameStr));
assert(isequal(length(idx), 1));
% Tolerance must be low b/c we are looking at conversion from formatted string
% Strip leading and trailing '$'
betaStr = char(outS.betaV(3));
betaStr = betaStr(2 : (end-1));
checkLH.approx_equal(mdl.Coefficients.Estimate(idx),  str2double(betaStr),  1e-2, []);


% Test removing underscore from coefficient name
varNameStr = 'x1';
idx = find(strcmp(mdl.CoefficientNames, varNameStr));
assert(isequal(length(idx), 1));


end