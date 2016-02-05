% Budget constraint object for backward induction testing
classdef BackwardInductionTestBc
   
properties
   kMin
   y
   cFloor
   R
end


methods
   function bcS = BackwardInductionTestBc(kMin, y)
      bcS.kMin = kMin;
      bcS.y = y;
      bcS.cFloor = 1e-4;
      bcS.R = 1.05;
   end
   
   
   function [kMin, kMax] = kPrimeRange(bcS, k)
      kMin = bcS.kMin;
      kMax = bcS.y + bcS.R * k - bcS.cFloor;
   end
   
   function c = getc(bcS, k, kPrime)
      c = bcS.y + bcS.R * k - kPrime;
   end
   
   function kPrime = getKPrime(bcS, k, c)
      kPrime = bcS.y + bcS.R * k - c;
   end
end
   
   
end