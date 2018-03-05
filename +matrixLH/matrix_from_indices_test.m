classdef matrix_from_indices_test < matlab.unittest.TestCase
    
properties (TestParameter)
   nd = {2, 3}; 
end

%methods (TestMethodSetup)
%  function x(tS)
%            
%  end
%end


methods (Test)
   function oneTest(tS, nd)
      rng('default');
      sizeV = 3 : 10;
      inM = randi(100, sizeV(1 : nd));
      idx1M = randi(sizeV(1), size(inM));
      idx2M = randi(sizeV(2), size(inM));
      idx3M = randi(sizeV(3), size(inM));
      
      
      switch nd
         case 2
            outM = matrixLH.matrix_from_indices(inM, idx1M, idx2M);

            out2M = zeros(size(outM));
            for i1 = 1 : size(idx1M, 1)
               for i2 = 1 : size(idx1M, 2)
                  out2M(i1, i2) = inM(idx1M(i1, i2), idx2M(i1, i2));
               end
            end
         case 3
            outM = matrixLH.matrix_from_indices(inM, idx1M, idx2M, idx3M);

            out2M = zeros(size(outM));
            for i1 = 1 : size(idx1M, 1)
               for i2 = 1 : size(idx1M, 2)
                  for i3 = 1 : size(idx1M, 3)
                     out2M(i1, i2, i3) = inM(idx1M(i1, i2, i3), idx2M(i1, i2, i3), idx3M(i1, i2, i3));
                  end
               end
            end
         otherwise
            error('invalid')
      end
      
      tS.verifyEqual(outM, out2M);
   end
end
   
end