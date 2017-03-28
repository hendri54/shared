function tests = LinearModelLHtest

tests = functiontests(localfunctions);

end


function oneTest(testCase)

disp('Testing linear model');

rng(342);
n = 133;
useWeights = 0;
wtV = [];
sigma1 = 0.2;

% Non-categorical
nx = 2;
betaXV = linspace(-0.5, 0.3, nx)';
xM = randn(n, nx);
yV = xM * betaXV  +  sigma1 * randn(n,1);

% Categorical
nCat = 3;
xCatM = zeros(n, nCat);
for i1 = 1 : nCat
   % No of values
   nv = 2 + round(rand(1,1) * 10);
   catS.valueV = (10 * i1) + (1 : n)';
   catS.betaV  = linspace(-0.3, 0.8, n)' + i1;

   catS.idxV = randi([1, nv], n, 1);
   xCatM(:, i1) = catS.valueV(catS.idxV);
   yV = yV + catS.betaV(catS.idxV);
end
validateattributes(xCatM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'size', [n, nCat]})

mS = regressLH.LinearModelLH(yV, xM, xCatM, wtV, useWeights)

assert(isequal(mS.nx, nx));
assert(isequal(mS.nCat, nCat));

[tbM, modelStr] = mS.make_table;
disp(modelStr)

[mdl, dummyV] = mS.regress;
for i1 = 1 : nCat
   dS = dummyV{i1};
   % Make sure all dummies were found (except the first (default))
   validateattributes(dS.idxV(2 : end), {'double'}, {'finite', 'nonnan', 'nonempty', 'integer', '>=', 1})
end


end