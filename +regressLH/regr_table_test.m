function tests = regr_table_test

tests = functiontests(localfunctions);

end


function oneTest(tS)

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

tS.verifyEqual(size(tbM),  [1 + 2 * nVar, 1 + nModels]);

% All entries must be char (except top left
ischarM = false(size(tbM));
for ir = 1 : size(tbM, 1)
   for ic = 1 : size(tbM, 2)
      ischarM(ir, ic) = ischar(tbM{ir, ic});
   end
end
ischarM(1,1) = true;
tS.verifyTrue(all(ischarM(:)));

% All entries in the body must be numeric
isnumM = true(size(tbM));
for ir = 2 : size(tbM, 1)
   for ic = 2 : size(tbM, 2)
      isnumM(ir, ic) = valid_number(tbM{ir, ic});
   end
end
tS.verifyTrue(all(isnumM(:)));


end


function result = valid_number(inStr)
   assert(ischar(inStr));
   if inStr(1) == '$'
      inStr = inStr(2 : (end-1));
   end
   if inStr(1) == '('
      inStr = inStr(2 : (end-1));
   end
   xNum = str2double(inStr);
   result = ~isnan(xNum);
end