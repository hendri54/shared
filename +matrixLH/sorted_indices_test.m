classdef sorted_indices_test < matlab.unittest.TestCase
    
properties (TestParameter)
   nd = {2, 3};      % Also test for vectors +++++        
end

methods (Test)
   function oneTest(tS, nd)
      dbg = 111;
      rng('default')
      % size of matrix
      sizeV = 3 + (1 : nd);
      inM = rand(sizeV);
      
      % Each column contains indices along one dim of inM
      idxM = matrixLH.sorted_indices(inM);
      
      % Sort inM using sorted indices
      sortIdxV = matrixLH.sub2ind(sizeV, idxM, dbg);
      
      % This should yield the same as sorting inM directly
      tS.verifyEqual(inM(sortIdxV), sort(inM(:)), 'AbsTol', 1e-8);
   end
end
   
end