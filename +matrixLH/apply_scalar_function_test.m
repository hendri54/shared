function apply_scalar_function_test

disp('Testing apply_scalar_function');

for nDim = 3 : 5
   rng(43);
   % Size of matrix
   sizeV = round(linspace(8, 2, nDim));
   inM = randn(sizeV);
   dbg = 111;
   fHandle = @sum;

   for iDim = 1 : nDim

      outM = matrixLH.apply_scalar_function(inM, fHandle, iDim, dbg);

      sum1M = squeeze(sum(inM, iDim));

      checkLH.approx_equal(outM, sum1M, 1e-7, []);
   end
end

end