function extreme_value_decision_test

n = 4;
prefScale = 2;
dbg = 111;


for nTypes = [1, 3]

   if nTypes == 1
      value_ixM = linspace(100, 110, n);
   else
      value_ixM = linspace(1, 0.9, nTypes)' * linspace(100, 110, n);
   end

   [prob_ixM, eVal_iV] = econLH.extreme_value_decision(value_ixM, prefScale, dbg);
   
   test_by_sim(value_ixM, prob_ixM, eVal_iV, prefScale);
end


end

%% Test by simulation
function test_by_sim(value_ixM, prob_ixM, eVal_iV, prefScale)

[nTypes, n] = size(value_ixM);

nSim = 1e5;

for iType = 1 : nTypes
   % Random vars for all alternatives
   rng('default');
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