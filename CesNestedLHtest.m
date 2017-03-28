function tests = CesNestedLHtest

tests = functiontests(localfunctions);

end


function oneTest(testCase)

% Change: no need for alphas to sum to 1 (except cobb-douglas) +++++

fprintf('Testing nested ces \n');
rng(32);
for substElast = [0.5, 1, 2.5]
   % Factor weights
   % Must sum to 1 in each group (if Cobb-Douglas)
   if abs(substElast - 1) < 0.05
      alphaTopSum = 1;
   else
      alphaTopSum = 0.7;
   end
   
   ng = 3;
   nV = (2 : (ng+1))';
   nV(2) = 1;
   substElastV = linspace(1, 2, ng)';
   T = 5;
   
   % Cobb Douglas: must sum to 1
   alphaSumV = linspace(1, 0.5, ng)';
   alphaSumV(nV == 1) = 1;

   fS = CesNestedLH(substElast,  nV, substElastV);

   % Factor weights
   % Must sum to 1 in each group (if Cobb-Douglas)
   
   nInputs = sum(nV);
   alphaM = nan([T, nInputs]);
   for ig = 1 : ng
      gIdxV = fS.gLbV(ig) : fS.gUbV(ig);
      aM = 1 + rand(T, length(gIdxV));
      alphaM(:, gIdxV) = aM ./ (sum(aM, 2) * ones(1, length(gIdxV))) .* alphaSumV(ig);
   end
   xM = 1 + rand([T, nInputs]);
   fS.sub_outputs(alphaM, xM);


   % Output
   AV = 10 .* rand(T, 1);
   alphaTopM = 1 + rand(T, ng);
   alphaTopM = alphaTopM ./ (sum(alphaTopM, 2) * ones(1, ng)) .* alphaTopSum;
   fS.output(AV, alphaTopM, alphaM, xM);


   mp_tester(fS, AV, alphaTopM, alphaM, xM);
   weight_tester(fS, AV, alphaTopM, alphaM, xM, alphaTopSum, alphaSumV);
end

end



%% Test marginal products
function mp_tester(fS, AV, alphaTopM, alphaM, xM)
   nInputs = sum(fS.nV);
   yV = fS.output(AV, alphaTopM, alphaM, xM);
   mpM = fS.mproducts(AV, alphaTopM, alphaM, xM);

   dx = 1e-5;
   for i1 = 1 : nInputs
      x2M = xM;
      x2M(:, i1) = x2M(:, i1) + dx;
      y2V = fS.output(AV, alphaTopM, alphaM, x2M);
      mpV = (y2V - yV) ./ dx;
      diffV = mpV - mpM(:, i1);
      if any(abs(diffV ./ max(0.1, mpM(:, i1))) > 1e-3)
         warning('Marginal products wrong');
         keyboard;
      end
   end
end


%% Test recovery of factor weights
function weight_tester(fS, AV, alphaTopM, alphaM, xM, alphaTopSum, alphaSumV)
   mpM = fS.mproducts(AV, alphaTopM, alphaM, xM);
   incomeM = mpM .* xM;
   
   [alphaTop2M, alpha2M, A2V] = fS.factor_weights(incomeM, xM, alphaTopSum, alphaSumV);
   
   if ~checkLH.approx_equal(alphaTop2M, alphaTopM, 1e-3, [])
      warning('alphaTop wrong');
      keyboard;
   end
   if ~checkLH.approx_equal(alpha2M, alphaM, 1e-3, [])
      warning('alpha wrong');
      keyboard;
   end
   checkLH.approx_equal(A2V, AV, [], 1e-4);
end
