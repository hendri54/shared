%{
Ben Porath model

h' = (1-ddh) * h + A * (h * l) ^ pAlpha

Test: testBenPorathLH

%}
classdef BenPorathLH
   properties
      pAlpha
      ddh
      A
      % Interest rate
      R
      % Time endowment by age
      tEndowV
      % Wage by age
      wageV
      % Training time cannot exceed this value
      trainTimeMax
      % Cap h at this value to avoid ridiculous values when alpha near 1
      hMax
   end
   
   methods
      % ***  Constructor
      function bpS = BenPorathLH(wageV, tEndowV, pAlpha, ddh, A, R, trainTimeMax, hMax)
         bpS.tEndowV = tEndowV(:);
         bpS.wageV = wageV(:);
         bpS.pAlpha = pAlpha;
         bpS.ddh = ddh;
         bpS.A = A;
         bpS.R = R;
         bpS.trainTimeMax = trainTimeMax;
         bpS.hMax = hMax;
      end
      
      
      % ***  Validation
      function validate(bpS)
         T = length(bpS.tEndowV);
         validateattributes(bpS.tEndowV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive', ...
            'size', [T, 1]})
         validateattributes(bpS.wageV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive', ...
            'size', [T, 1]})
         validateattributes(bpS.pAlpha, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'scalar', ...
            '>', 0.05, '<', 0.99})
         validateattributes(bpS.ddh, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'scalar', ...
            '>=', 0,  '<', 0.3})
         validateattributes(bpS.R, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'scalar', '>', 0.5})
      end
      
      
      % ***  h' law of motion
      % Not capped at hMax
      function hPrimeV = hprime(bpS, hV, lV, pProductV, dbg)
         hPrimeV = hV .* (1 - bpS.ddh) + pProductV .* ((hV .* lV) .^ bpS.pAlpha);
      end
      
      
      % *** Time path of h for given study times
      % Capped at hMax
      function h_itM = hpath(bpS, h1V, l_itM, pProductV, dbg)
         [~, T] = size(l_itM);
         h_itM = zeros(size(l_itM));
         h_itM(:, 1) = h1V(:);
         for t = 1 : (T-1)
            h_itM(:, t+1) = h_itM(:, t) .* (1 - bpS.ddh) + pProductV .* ((h_itM(:, t) .* l_itM(:, t)) .^ bpS.pAlpha);
         end
      end
      
      
      % ***  Earnings and wages, given h, l
      function [earn_itM, wage_itM] = earnings(bpS, h_itM, l_itM, dbg)
         % Earnings = w * h * (tEndow - l)
         n = size(h_itM, 1);
         earn_itM = (ones([n, 1]) * bpS.wageV(:)') .* h_itM .* (ones([n,1]) * bpS.tEndowV(:)' - l_itM);
         % Wage = earnings / time endowment
         wage_itM = earn_itM ./ (ones([n,1]) * bpS.tEndowV(:)');
      end
   end

end