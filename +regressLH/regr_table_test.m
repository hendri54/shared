function tests = regr_table_test

tests = functiontests(localfunctions);

end


function oneTest(testCase)

disp('Testing regr_table');

nModels = 3;
nVar = 4;
rng(43);
dbg = 111;

%% Make regression models

nObsV = round(100 + 100 * rand(nModels, 1));
mdlV = cell(nModels, 1);
modelNameV = cell(nModels, 1);

for iModel = 1 : nModels
   xM = randn(nObsV(iModel), nVar);
   yV = xM * randn(nVar, 1) + randn(nObsV(iModel), 1);
   mdlV{iModel} = fitlm(xM, yV);
   
   modelNameV{iModel} = sprintf('Model %i', iModel);
end

varNameV = {'x1', 'x3', 'x4'};
varLabelV = {'$\phi_{1}$', 'x3', 'var4'};

tbM = regressLH.regr_table(mdlV, varNameV, varLabelV, modelNameV, dbg);



end