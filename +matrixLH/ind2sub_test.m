classdef ind2sub_test < matlab.unittest.TestCase
    
properties (TestParameter)
   nd = {2, 5}
end
    
   %methods (TestMethodSetup)
   %  function x(tS)
   %            
   %  end
   %end
    
   
methods (Test)
   function oneTest(tS, nd)
      rng('default');
      sizeV = [4, 1, 7, 3, 2, 9, 8];
      sizeV = sizeV(1 : nd);
      idxV = round(linspace(1, prod(sizeV), 30));
      
      idxM = matrixLH.ind2sub(sizeV,  idxV);
      
      switch length(sizeV)
         case 2
            [x1, x2] = ind2sub(sizeV, idxV);
            idx2M = [x1(:), x2(:)];
         case 5
            [x1, x2, x3, x4, x5] = ind2sub(sizeV, idxV);
            idx2M = [x1(:), x2(:), x3(:), x4(:), x5(:)];
         otherwise
            error('Not implemented');
      end
      
      tS.verifyEqual(idxM, idx2M);
      
   end
end
   
end