classdef GuessUnbounded
   
properties
   xMinV  double
   xMaxV  double
end

methods
   %% Constructor
   function gS = GuessUnbounded(xMinV, xMaxV)
      gS.xMinV = xMinV;
      gS.xMaxV = xMaxV;
      
      assert(all(gS.xMaxV > gS.xMinV + 0.01));
   end
   
   
   %% Guess from values
   function outV = guesses(gS, valueV)
      outV = -log((gS.xMaxV - gS.xMinV) ./ max(1e-6, valueV - gS.xMinV) - 1);
      validateattributes(outV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real'})
   end
   
   
   %% Values from guess
   function outV = values(gS, guessV)
      outV = gS.xMinV + (gS.xMaxV - gS.xMinV) ./ (1 + exp(-guessV));
      validateattributes(outV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real'})
   end
end
   
   
end