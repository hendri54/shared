% Change: no need for alphas to sum to 1 (except cobb-douglas) +++++
classdef CesNestedLHtest <  matlab.unittest.TestCase
   
properties (TestParameter)
   substElast = {0.5, 1.0, 2.5}
   T = {1, 5}
end

methods (Test)   
   function oneTest(tS, substElast, T)
      rng(32);

      [fS, ng, nV, substElastV] = tS.setup(substElast);
      [alphaM, alphaSumV] = tS.make_alphas(fS, T, nV, ng);
      alphaTopM = tS.make_alpha_top(substElast, T, ng);

      nInputs = sum(nV);
      xM = 1 + rand([T, nInputs]);
      AV = 10 .* rand(T, 1);

      fS.sub_outputs(alphaM, xM);

      % Output
      fS.output(AV, alphaTopM, alphaM, xM);

      groupV = fS.groups_from_inputs(1);
      tS.verifyTrue(isequal(groupV, 1));

      groupV = fS.groups_from_inputs(1 : nInputs);
      for i1 = 1 : nInputs
         ig = groupV(i1);
         tS.verifyTrue(i1 >= fS.gLbV(ig)  &&  i1 <= fS.gUbV(ig));
      end
      
      inputV = fS.inputs_from_group(2);
      tS.verifyTrue(isequal(find(groupV == 2), inputV));
   end
   
   
   %% Test marginal products
   function mp_test(tS, substElast, T)
      rng('default');
      
      [fS, ng, nV, substElastV] = tS.setup(substElast);
      [alphaM, alphaSumV] = tS.make_alphas(fS, T, nV, ng);
      alphaTopM = tS.make_alpha_top(substElast, T, ng);

      nInputs = sum(fS.nV);
      xM = 1 + rand([T, nInputs]);
      AV = 10 .* rand(T, 1);
            

      yV = fS.output(AV, alphaTopM, alphaM, xM);
      mpM = fS.mproducts(AV, alphaTopM, alphaM, xM);

      dx = 1e-5;
      mp2M = zeros(size(mpM));
      for i1 = 1 : nInputs
         x2M = xM;
         x2M(:, i1) = x2M(:, i1) + dx;
         y2V = fS.output(AV, alphaTopM, alphaM, x2M);
         mpV = (y2V - yV) ./ dx;
         mp2M(:,i1) = mpV;
      end
      tS.verifyEqual(mp2M, mpM, 'AbsTol', 1e-3);
      
      incomeShareM = fS.income_shares(AV, alphaTopM, alphaM, xM);
      tS.verifyTrue(all(abs(sum(incomeShareM, 2) - 1) < 1e-5),  'Income shares do not sum to 1');
      
      groupShareM = fS.group_shares(incomeShareM);
      tS.verifyEqual(size(groupShareM), [T, ng]);
      groupSumV = sum(groupShareM, 2);
      tS.verifyTrue(all(abs(groupSumV - 1) < 1e-5));
   end
   
   
   %% Test recovery of factor weights
   function weight_test(tS, substElast, T)
      rng('default');
      [fS, ng, nV, substElastV] = tS.setup(substElast);
      [alphaM, alphaSumV] = tS.make_alphas(fS, T, nV, ng);
      [alphaTopM, alphaTopSum] = tS.make_alpha_top(substElast, T, ng);

      nInputs = sum(nV);
      xM = 1 + rand([T, nInputs]);
      AV = 10 .* rand(T, 1);

      mpM = fS.mproducts(AV, alphaTopM, alphaM, xM);
      incomeM = mpM .* xM;

      [alphaTop2M, alpha2M, A2V] = fS.factor_weights(incomeM, xM, alphaTopSum, alphaSumV);

      tS.verifyEqual(alphaTop2M, alphaTopM, 'AbsTol', 1e-3)
      tS.verifyEqual(alpha2M, alphaM, 'AbsTol', 1e-3)
      tS.verifyEqual(A2V, AV, 'AbsTol', 1e-4);
   end
   

%{   
   %% Test elasticity of substitution
   % This test fails. Reasons not known +++++
   % First and 3rd columns of elasticity matrix are correct. The others are wrong.
   function elast_test(tS, substElast, T)
      rng('default');
      [fS, ng, nV, substElastV] = tS.setup(substElast);
      [alphaM, alphaSumV] = tS.make_alphas(fS, T, nV, ng);
      [alphaTopM, alphaTopSum] = tS.make_alpha_top(substElast, T, ng);

      nInputs = sum(nV);
      xM = 1 + rand([T, nInputs]);
      AV = 10 .* rand(T, 1);
      
      t = 1;
      function mpV = mp_fct(xV)
         mpV = fS.mproducts(AV(t), alphaTopM(t,:), alphaM(t,:), xV(:)');
      end

      assert(nV(end) > 1);
      i1 = nInputs;
      i2V = 1 : nInputs;
      i2V(i1) = [];
      elastV = econLH.elasticity_substitution(@mp_fct, xM(t,:), i1, i2V);
      tS.verifyEqual(elastV(end), substElastV(end), 'AbsTol', 1e-3);
      
      assert(nV(1) > 1);
      i1 = 1;
      i2V = 1 : nInputs;
      i2V(i1) = [];
      elastV = econLH.elasticity_substitution(@mp_fct, xM(t,:), i1, i2V);
      tS.verifyEqual(elastV(1), substElastV(1), 'AbsTol', 1e-3);
      
      % Make entire elasticity matrix
      elastM = econLH.elasticity_substitution(@mp_fct, xM(t,:), 1 : nInputs, 1 : nInputs);
      % It should be symmetric
      diffM = elastM - elastM';
      maxDiff = max(abs(diffM(:)), [], 1, 'omitnan');
      
%       disp(diffM)
%       keyboard; % +++++
      
      tS.verifyTrue(maxDiff < 1e-3,  sprintf('Elasticity matrix not symmetric. Deviation %.3f', maxDiff));
   end
%}
   
   
   %% All elasticities the same. It should become CES
   function allElastSameTest(tS, substElast, T)
      % Not implemented when all elasticities are 1
      if abs(substElast - 1) < 1e-5
         return
      end
      
      ng = 3;
      nV = (2 : (ng+1))';
      nV(2) = 1;
      substElastV = repmat(substElast, [ng, 1]);

      fS = CesNestedLH(substElast,  nV, substElastV);
      alphaM = tS.make_alphas(fS, T, nV, ng);
      alphaTopM = tS.make_alpha_top(substElast, T, ng);

      nInputs = sum(nV);
      xM = 1 + rand([T, nInputs]);
      AV = 10 .* rand(T, 1);
      
      t = T;
      function mpV = mp_fct(xV)
         mpV = fS.mproducts(AV(t), alphaTopM(t,:), alphaM(t,:), xV(:)');
      end

      i1V = 1 : nInputs;
      i2V = 1 : nInputs;
      elastM = econLH.elasticity_substitution(@mp_fct, xM(t,:), i1V, i2V);
      diffM = tS.elast_differences(elastM, repmat(substElast, size(elastM)));
      maxDiff = max(abs(diffM(:)));
      tS.verifyTrue(maxDiff < 1e-3,  sprintf('Max diff from expected elasticities: %.3f', maxDiff));
   end
   
   
   %% Direct call to analytical elasticity
   function elastSatoDirectTest(tS, substElast, T)
      rng('default');
      [fS, ng, nV, substElastV] = tS.setup(substElast);
      alphaM = tS.make_alphas(fS, T, nV, ng);
      alphaTopM = tS.make_alpha_top(substElast, T, ng);

      nInputs = sum(nV);
      xM = 1 + rand([T, nInputs]);
      AV = 10 .* rand(T, 1);

      elast_ijtM = fS.elast_subst_from_inputs(AV, alphaTopM, alphaM, xM);

      [withinCorrect, betweenCorrect, isSymmetric] = fS.check_elastity_matrix(elast_ijtM);
      tS.verifyTrue(withinCorrect,  'Within group elasticities wrong');
      tS.verifyTrue(betweenCorrect,  'Between group elasticities wrong');
      tS.verifyTrue(isSymmetric, 'Matrix not symmetric');
         
         
      % Elasticity ranges within and between
      withinCorrect = true;
      betweenCorrect = true;
      [min_ggtM, max_ggtM] = fS.elasticity_ranges(elast_ijtM);
      for g1 = 1 : ng
         for g2 = 1 : ng
            minV = squeeze(min_ggtM(g1,g2,:));
            maxV = squeeze(max_ggtM(g1,g2,:));
            if g1 == g2
               valid = all(minV > substElastV(g1) - 1e-8)  &&  all(maxV < substElastV(g1) + 1e-8);
               if ~valid
                  withinCorrect = false;
               end
            else
               % Between
               rangeV = [substElast; substElastV(g1); substElastV(g2)];
               valid = all(minV > min(rangeV) - 1e-6)  &&  all(maxV < max(rangeV) + 1e-6);
               if ~valid
                  betweenCorrect = false;
               end
            end
         end
      end
      tS.verifyTrue(withinCorrect,  'Within group elasticities out of bounds');
      tS.verifyTrue(betweenCorrect,  'Between group elasticities out of bounds');
      
   end
   
   
   %% Analytical elasticity of substitution
   function elastSatoTest(tS, substElast)
      [fS, ng, nV, substElastV] = tS.setup(substElast);
      
      groupShareV = linspace(2, 3, ng);
      groupShareV = groupShareV ./ sum(groupShareV);
      
      nInputs = sum(nV);
      incomeShareV = zeros(nInputs, 1);
      for ig = 1 : ng
         inputV = fS.inputs_from_group(ig);
         shareV = linspace(3, 2, length(inputV));
         incomeShareV(inputV) = shareV ./ sum(shareV) .* groupShareV(ig);
      end
      
      % Within
      for ig = 1 : ng
         inputV = fS.inputs_from_group(ig);
         if length(inputV) > 1
            elast = fS.elast_substitution(inputV(1), inputV(end), incomeShareV, groupShareV);
            tS.verifyEqual(elast, substElastV(ig), 'AbsTol', 1e-6);
         end
      end
      
      % Between
      g1 = 1;
      g2 = ng;
      i1 = 1;
      i2 = nInputs;
      elast = fS.elast_substitution(i1, i2, incomeShareV, groupShareV);
      withinElastV = substElastV([g1, g2]);
      % Expect elasticity to be a convex combination of the 3 elasticities involved
      tS.verifyTrue(elast > min([withinElastV(:); substElast]));
      tS.verifyTrue(elast < max([withinElastV(:); substElast]));
   end
end




methods (Static)
   %% Setup
   function [fS, ng, nV, substElastV] = setup(substElast)
      ng = 3;
      nV = (2 : (ng+1))';
      nV(2) = 1;
      substElastV = linspace(1, 2, ng)';
      fS = CesNestedLH(substElast,  nV, substElastV);
   end

   
   function [alphaM, alphaSumV] = make_alphas(fS, T, nV, ng)
      nInputs = sum(nV);
      
      % Cobb Douglas: must sum to 1
      alphaSumV = linspace(1, 0.5, ng)';
      alphaSumV(nV == 1) = 1;

      alphaM = nan([T, nInputs]);
      for ig = 1 : ng
         gIdxV = fS.gLbV(ig) : fS.gUbV(ig);
         aM = 1 + rand(T, length(gIdxV));
         alphaM(:, gIdxV) = aM ./ (sum(aM, 2) * ones(1, length(gIdxV))) .* alphaSumV(ig);
      end      
   end
   

   function [alphaTopM, alphaTopSum] = make_alpha_top(substElast, T, ng)
      % Factor weights
      % Must sum to 1 in each group (if Cobb-Douglas)
      if abs(substElast - 1) < 0.05
         alphaTopSum = 1;
      else
         alphaTopSum = 0.7;
      end
      alphaTopM = 1 + rand(T, ng);
      alphaTopM = alphaTopM ./ (sum(alphaTopM, 2) * ones(1, ng)) .* alphaTopSum;
   end
   
   
   %% Compare two elasticity matrices, but not their diagonals (which are undefined)
   %{
   OUT
      diffM  ::  matrix of differences (0 on diagonal)
   %}
   function diffM = elast_differences(e1M, e2M)
      diffM = matrixLH.set_diagonal(e2M - e1M, 0);
   end
end

end