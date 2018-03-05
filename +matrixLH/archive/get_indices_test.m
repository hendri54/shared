classdef get_indices_test < matlab.unittest.TestCase
    
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
      dbg = 111;
      rng('default');
      
      sizeV = round(linspace(3, 15, nd));
      m = randi(100, sizeV);

      idxM = matrixLH.get_indices(m);
      tS.verifyEqual(size(idxM),  [numel(m), nd]);
      
      % idxV = ind2sub(sizeV, idxM);
      outV = sub2ind_lh2(sizeV, idxM, dbg);
      tS.verifyEqual(m(:), m(outV));
      

%       m2M = zeros(size(m));
%       for ir = 1 : size(idxM, 1)
%          m2M
%             if nd == 2
%                m2M(i2, i1) = m(idxM(
%             else
%             end
%       end
   end
end
   
end