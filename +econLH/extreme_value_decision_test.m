function extreme_value_decision_test

nTypes = 3;
n = 4;
value_ixM = linspace(1, 0.9, nTypes)' * linspace(100, 110, n);
prefScale = 2;
dbg = 111;

[prob_ixM, eVal_iV] = econLH.extreme_value_decision(value_ixM, prefScale, dbg);


%% Test by simulation

nSim = 1e5;
% Draw type I extreme value shocks
rng(32);

for iType = 1 : nTypes
   % Random vars for all alternatives
   randM = evrnd(0, 1, [nSim, n]);

   % Values including pref shocks
   valueM = ones([nSim, 1]) * value_ixM(iType, :)  -  randM .* prefScale;

   % Find the max index
   [maxV, maxIdxV] = max(valueM, [], 2);
   validateattributes(maxIdxV(:), {'double'}, {'finite', 'nonnan', 'nonempty', 'integer', 'size', [nSim, 1]});

   cntV = accumarray(maxIdxV(:), 1, [n, 1]);
   cntV = cntV(:) ./ nSim;

   diffV = cntV - prob_ixM(iType, :)';

   if any(abs(diffV) > 5e-3)
      fprintf('True probs:  ');
      fprintf('  %8.3f',   prob_ixM(iType, :));
      fprintf('\nSim probs:   ');
      fprintf('  %8.3f',   cntV);
      fprintf('\n');
      warning('Failed');
      keyboard;
   end

   % Check expected value
   simVal = mean(maxV);
   if abs(simVal ./ eVal_iV(iType) - 1) > 1e-3
      fprintf('Discrepancy in values: %.3f vs %.3f \n',  simVal, eVal_iV);
      keyboard;
   end
end


end