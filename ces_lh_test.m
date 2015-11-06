function ces_lh_test
   fprintf('Testing ces_lh \n');

   for N = [1, 3]
      for substElast = [2.5, 1, 0.5] 
         if abs(substElast - 1) < 0.05
            alphaSum = 1;
         else
            alphaSum = 2.5;
         end
         T = 5;
         AV = linspace(0.5, 1.5, T)';
         if N == 1
            alphaM = ones(T, 1);
            xM = linspace(1, 2, T)';
         else
            alphaM = linspace(1.1, 0.9, T)' * linspace(0.1, 0.2, N);
            xM = linspace(1,2,T)' * linspace(1,2,N);
            % alphaM must sum to alphaSum
            alphaM = alphaM ./ (sum(alphaM, 2) * ones(1, N)) .* alphaSum;
         end
         
         fS = ces_lh(substElast, N,  AV, alphaM, xM);
         fS.validate;

         % Output
         yV = fS.output;
         y2V = fS.output(AV, alphaM, xM);
         if ~checkLH.approx_equal(y2V, yV, 1e-7, [])
            error('Outputs do not match');
         end
         clear y2V;
         
%          % Scaling: multiply all alphas by a factor. Divide AV by the same factor.
%          % Output should be unchanged
%          y2V = fS.output(AV .* 1.5, alphaM ./ 1.5, xM);
%          checkLH.approx_equal(y2V, yV, 1e-7, []);

         mp_test(fS);
         factor_weights_test(fS);
      end
   end
end


%%  Test marginal products
function mp_test(fS)
   % fprintf('Testing marginal products\n');
   [T, n] = size(fS.alphaM);
   % If Cobb-Douglas: alphas must sum to 1
   if abs(fS.substElast - 1) < 0.05
      fS.alphaM = fS.alphaM ./ repmat(sum(fS.alphaM, 2), [1, n]);
   end
   
   yV = fS.output;
   mpM = fS.mproducts;
   mp2M = fS.mproducts(fS.AV, fS.alphaM, fS.xM);
   if ~checkLH.approx_equal(mp2M, mpM, 1e-5, [])
      error('MPs do not match');
   end
   clear mp2M;
   
   % Check that doubling A doubles marginal products
   mp3M = fS.mproducts(fS.AV * 2, fS.alphaM, fS.xM);
   checkLH.approx_equal(mp3M, mpM .* 2, 1e-5, []);
   
   % Check that doubling alpha doubles marginal products
   if abs(fS.substElast - 1) > 1e-2
      mp3M = fS.mproducts(fS.AV, fS.alphaM .* 2, fS.xM);
      checkLH.approx_equal(mp3M, mpM .* 2, 1e-5, []);
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
   checkLH.approx_equal(y2V, yV, [], 1e-4);
   
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
function factor_weights_test(fS)
   mpM = fS.mproducts;
   
   alphaSum = sum(fS.alphaM(1,:));
   
   [alpha2M, A2V] = fS.factor_weights(mpM .* fS.xM, fS.xM, alphaSum);
   if ~checkLH.approx_equal(alpha2M, fS.alphaM, 1e-4, [])
      warning('alphas do not match');
      keyboard;
   end
   checkLH.approx_equal(A2V, fS.AV, [], 1e-4);

end
