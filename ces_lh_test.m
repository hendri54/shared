classdef ces_lh_test < matlab.unittest.TestCase
   
properties (TestParameter)
   N = {1, 3}
   substElast = {0.5, 1.0, 2.5}
end

methods (Test)
   function oneTest(tS, N, substElast)
      fS = tS.case_setup(N, substElast);
      % Output
      yV = fS.output;
      y2V = fS.output(fS.AV, fS.alphaM, fS.xM);
      tS.verifyEqual(y2V, yV, 'AbsTol', 1e-7)
      clear y2V;

      tS.mp_tester(fS);
      tS.factor_weights_tester(fS);
   end
end


methods
   %% Setup
   function fS = case_setup(tS, N, substElast)
      if abs(substElast - 1) < 0.05
         alphaSum = 1;
      else
         alphaSum = 2.5;
      end
      T = 5;
      AV = linspace(0.5, 1.5, T)';
      if N == 1
         alphaM = alphaSum .* ones(T, 1);
         xM = linspace(1, 2, T)';
      else
         alphaM = linspace(1.1, 0.9, T)' * linspace(0.1, 0.2, N);
         xM = linspace(1,2,T)' * linspace(1,2,N);
         % alphaM must sum to alphaSum
         alphaM = alphaM ./ (sum(alphaM, 2) * ones(1, N)) .* alphaSum;
      end

      fS = ces_lh(substElast, N,  AV, alphaM, xM);
      fS.validate;
   end
   
   
   %%  Test marginal products
   function mp_tester(tS, fS)
      % fprintf('Testing marginal products\n');
      [T, n] = size(fS.alphaM);
      % If Cobb-Douglas: alphas must sum to 1
      if abs(fS.substElast - 1) < 0.05
         fS.alphaM = fS.alphaM ./ repmat(sum(fS.alphaM, 2), [1, n]);
      end

      yV = fS.output;
      mpM = fS.mproducts;
      mp2M = fS.mproducts(fS.AV, fS.alphaM, fS.xM);
      tS.verifyEqual(mpM, mp2M, 'AbsTol', 1e-5);
      clear mp2M;

      % Check that doubling A doubles marginal products
      mp3M = fS.mproducts(fS.AV * 2, fS.alphaM, fS.xM);
      tS.verifyEqual(mp3M, mpM .* 2, 'AbsTol', 1e-5);

      % Check that doubling alpha doubles marginal products
      if abs(fS.substElast - 1) > 1e-2
         mp3M = fS.mproducts(fS.AV, fS.alphaM .* 2, fS.xM);
         tS.verifyEqual(mp3M, mpM .* 2, 'AbsTol', 1e-5);
      end

      % Check that raising an input lowers its MP
      if fS.N > 1 
         dx = 0.5;
         for j = 1 : fS.N
            mpM = fS.mproducts(fS.AV, fS.alphaM, fS.xM);
            x2M = fS.xM;
            x2M(:,j) = fS.xM(:,j) + dx;
            mp2M = fS.mproducts(fS.AV, fS.alphaM, x2M);
            mpDiffM = mp2M - mpM;
            if any(mpDiffM(:, j) >= 0)
               error('MP should decline');
            end
         end
      end

      % Check that MP * x adds up to income
      y2V = sum(mpM .* fS.xM, 2);
      tS.verifyEqual(y2V, yV, 'RelTol', 1e-4);

      % Numerically check marginal products
      dx = 1e-5;
      for j = 1 : fS.N
         x2M = fS.xM;
         x2M(:,j) = fS.xM(:,j) + dx;
         y2V = fS.output([], [], x2M);

         mp2V = (y2V - yV) ./ dx;
         if any(abs((mp2V - mpM(:,j)) ./ max(1e-3, mpM(:,j))) > 1e-4)
            fprintf('Marginal products are off \n');
            keyboard;
         end
      end
   end


   %%  Test factor weights
   function factor_weights_tester(tS, fS)
      mpM = fS.mproducts;

      alphaSum = sum(fS.alphaM(1,:));

      [alpha2M, A2V] = fS.factor_weights(mpM .* fS.xM, fS.xM, alphaSum);
      tS.verifyEqual(alpha2M, fS.alphaM, 'AbsTol', 1e-4)
      tS.verifyEqual(A2V, fS.AV, 'RelTol', 1e-4);
   end
   
end

end
