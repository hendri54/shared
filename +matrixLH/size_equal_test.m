function tests = size_equal_test

tests = functiontests(localfunctions);

end

function oneTest(tS)
   sizeV = [1,3,2];
   tS.verifyTrue(matrixLH.size_equal(sizeV, sizeV));
   tS.verifyTrue(matrixLH.size_equal(sizeV, [sizeV, 1, 1]));
   tS.verifyFalse(matrixLH.size_equal(sizeV, [sizeV, 2]));
   
   size2V = sizeV;
   size2V(2) = sizeV(2) + 1;
   tS.verifyFalse(matrixLH.size_equal(size2V, sizeV));
   
   tS.verifyTrue(matrixLH.size_equal([1,1], [1,1,1]));
end