function tests = multi_test

tests = functiontests(localfunctions);

end


function oneTest(testCase)


%% Make a regression model for test purposes
% There is now a function for that: make_test_model

rng(32);
dbg = 111;
ageV = (30:35)';
yearV = (1980 : 1987)';
sigma1 = 0.2;

nAge = length(ageV);
ny = length(yearV);
nx = 4;

betaYearV = linspace(0.5, 1.5, ny)';
betaAgeV = linspace(3.3, 1.1, nAge)';
betaXV = linspace(-1.2, 0.3, nx)';
xNameV = string_lh.vector_to_string_array(1 : nx, 'x_%i');

year_ayM = repmat(yearV(:)', [nAge, 1]);
age_ayM = repmat(ageV(:), [1, ny]);
x_ayvM = randn([nAge, ny, nx]) .* 5;


%% Build up the model

y_ayM = repmat(betaAgeV(:), [1, ny])  +  repmat(betaYearV(:)', [nAge, 1])  +  sigma1 * randn([nAge, ny]);
tbM = table(y_ayM(:),  nominal(age_ayM(:)),  nominal(year_ayM(:)),  'VariableNames', {'y', 'age', 'year'});

modelStr = 'y~1+age+year';

for ix = 1 : nx
   xNewM = x_ayvM(:,:,ix);
   tbM.(xNameV{ix}) = xNewM(:);
   y_ayM = y_ayM + betaXV(ix) .* xNewM;
   modelStr = [modelStr, '+', xNameV{ix}];
end

tbM.y = y_ayM(:);

% summary(tbM)

mdl = fitlm(tbM,  modelStr);


%% Recover dummies

ageIdxV = regressLH.dummy_pointers(mdl, 'age', ageV, dbg);
assert(isequal(ageIdxV(2:end),  (2 : nAge)'));
assert(isnan(ageIdxV(1)));

% Also works for other variables named 'x_i'
xIdxV = regressLH.dummy_pointers(mdl, 'x', 1 : nx, dbg);
assert(isequal(length(xIdxV), nx));
for ix = 1 : nx
   assert(strcmp(mdl.CoefficientNames{xIdxV(ix)},  xNameV{ix}))
end

% More general function to find regressors by name
rNameV = {'x_1', 'x_2'};
rIdxV = regressLH.find_regressors(mdl, rNameV, dbg);
for ix = 1 : length(rNameV)
   assert(strcmp(mdl.CoefficientNames{rIdxV(ix)},  rNameV{ix}))
end
clear rIdxV


end


