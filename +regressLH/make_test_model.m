function [mdl, outS] = make_test_model
% Make a linear model for testing regression related functions
%{
y = y0 + cat1 + cat2 + ... + var1 + var2 + ...

Verify visually that coefficents line up with assumed betaV
%}

rng('default');
n = 5000;

tbM = table(zeros(n,1));
betaV = -2 : 2;
modelStr = 'y~';

% Intercept and error term
beta0 = 0.5;
y = beta0 * ones(n, 1) + randn(n, 1);

% Categorical variables
for i1 = 1 : 2
   xV = randi(2 + i1, [n, 1]);
   y = y + betaV(i1) .* xV;

   varName = sprintf('cat%i', i1);
   tbM.(varName) = nominal(xV);
   if i1 == 1
      modelStr = [modelStr, varName];
   else
      modelStr = [modelStr, '+', varName];
   end
end

% Continuous variables
for i1 = 1 : 4
   xV = rand([n, 1]);
   y = y + betaV(i1) .* xV;

   varName = sprintf('var%i', i1);
   tbM.(varName) = xV;
   modelStr = [modelStr, '+', varName];
end


%% Logical variables

nb = 2;
outS.boolS = struct;
outS.boolS.varNameV = cell(nb, 1);
outS.boolS.coeffV = linspace(1.5, 2.5, nb);

for i1 = 1 : nb
   varName = sprintf('bool%i', i1);
   outS.boolS.varNameV{i1} = varName;
   xV = rand([n, 1]) > 0.5;
   y = y + outS.boolS.coeffV(i1) .* double(xV);
   modelStr = [modelStr, '+', varName];
   tbM.(varName) = xV;
end

tbM.y = y;

mdl = fitlm(tbM, modelStr);


end