function [prob_ixM, eVal_iV] = extreme_value_decision(value_ixM, prefScale, dbg)
% Solve a decision problem with type I extreme value shocks
%{
Assumes that type I shocks have not been demeaned
If demeaned, subtract prefScale * Euler constant from expected value

IN
   value_ixM
      values of alternatives
      rows are types; columns are alternatives
      works with a single type
   prefScale
      scale of type I extreme value shocks

OUT
   prob_ixM
      probability of choosing each option
   eVal_iV
      expected value for each type

TEST
   by simulation in extreme_value_decision_test
%}

EulerConst = 0.5772;

[nTypes, nx] = size(value_ixM);

if nx == 1
   % One alternative
   % Decision prob is 1
   prob_ixM = ones([nTypes, nx]);
   % Value is value of that alternative + mean pref shock
   eVal_iV = value_ixM + EulerConst;
   return;
end

% Decision probability is log(sum(exp(V / prefScale)))
% This needs to be nicely scaled to avoid overflow
vMax_iV = max(value_ixM ./ prefScale, [], 2) - 4;
% The following line is expensive
exp_ixM = exp(value_ixM ./ prefScale - repmat(vMax_iV(:), [1, nx]));

% For each type: sum over alternatives
expSum_iV = sum(exp_ixM, 2);

% Prob of each choice
prob_ixM = exp_ixM ./ repmat(expSum_iV(:), [1, nx]);

% Expected value
eVal_iV = prefScale * (vMax_iV(:) + log(expSum_iV(:)) + EulerConst);


%% Test
if dbg
   validateattributes(exp_ixM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real'})
end

end