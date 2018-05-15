function tests = scale_cols_test

tests = functiontests(localfunctions);

end

function oneTest(tS)
   rng('default');
   sizeV = [16, 4];
   inM = rand(sizeV);
   missVal = -9191;
   dbg = 111;
   
   % Make some values out of bounds
   for i1 = 1 : 9
      ir = randi(sizeV(1));
      ic = randi(sizeV(2));
      offSet = randi(1) - 1;
      inM(ir, ic) = offSet;
   end

   lb = 0.02;
   ub = 0.98;
   outM = matrixLH.scale_cols(inM, lb, ub, missVal, dbg);
   validateattributes(outM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive', 'size', size(inM), ...
      '>', lb - 1e-8, '<', ub + 1e-8})
   
   % Column sums should not change
   tS.verifyEqual(sum(inM), sum(outM), 'AbsTol', 1e-6);
end