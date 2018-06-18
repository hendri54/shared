classdef interp_common_grid_test < matlab.unittest.TestCase
    
methods (Test)
   function oneTest(tS)
      n = 40;
      gridV = linspace(-2, 3, n)';
      fV = sin(gridV);
      [gridOutV, y_xfM] = interpLH.interp_common_grid([gridV(:), fV(:)]);
      
      tS.verifyEqual(gridV, gridOutV);
      tS.verifyEqual(fV, y_xfM);
   end
   
   
   function twoTest(tS)
      nf = 2;
      n = 150;
      functionV = tS.make_functions(nf, n);
      
      [gridOutV, y_xfM] = interpLH.interp_common_grid(functionV{:});
      
      for i1 = 1 : nf
         tS.check_function(i1, gridOutV, y_xfM(:,i1));
      end
   end
end


methods
   % Uses sin(x + i1) as test function
   function functionV = make_functions(tS, nf, n)
      functionV = cell(1, nf);
      
      for i1 = 1 : nf
         gridV = linspace(-2 + 0.1 * i1,  3 - 0.1 * i1,  n);
         fV = sin(gridV + i1);
         functionV{i1} = [gridV(:), fV(:)];
      end
   end
   
   
   % Tests that sin(x + i1) is recovered (or NaN when out of range)
   function check_function(tS, i1, gridV, fV)
      idxV = find(~isnan(fV));
      tS.verifyTrue(length(idxV) > 10);
      tS.verifyEqual(fV(idxV),  sin(i1 + gridV(idxV)),  'AbsTol', 1e-3);
   end
end
   
end