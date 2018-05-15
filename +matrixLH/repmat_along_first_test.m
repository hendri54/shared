classdef repmat_along_first_test < matlab.unittest.TestCase
    
properties (TestParameter)
   nd = {0, 1, 2, 3, 4}
end

methods (Test)
   function oneTest(tS, nd)
      if nd > 1
         sizeV = 5 : -1 : (5 - nd + 1);
      elseif nd == 1
         sizeV = [3, 1];
      else
         sizeV = [1, 3];
      end
      nd2 = length(sizeV);
      
      rng('default');
      x = randi(100, sizeV);
      
      nr = 7;
      z = matrixLH.repmat_along_first(x, nr);
      
      isValid = true;
      for ir = 1 : nr
         % Check that z(j,:,:) == x
         cln(1 : (nd2+1)) = {':'};
         cln{1} = ir;
         if nd == 0  ||  nd == 1
            % nd = 0: Input is row vector, but the squeeze(z) outputs a column vector
            % nd = 1: the other way around
            isValid = isequal(squeeze(z(cln{:})), x');
         else
            if ~isequal(squeeze(z(cln{:})), x)
               isValid = false;
            end
         end
      end
      
      tS.verifyTrue(isValid);
   end
end
   
end