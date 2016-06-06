function test_cont_value(spS)
% Test continuation value object

n = 20;
hV = linspace(0.2, 20, n)';
TV = linspace(0.3, 30, n)';

valueV = spS.cvS.value(hV, TV);
dVdhV  = spS.cvS.marginal_value_h(hV, TV);
validateattributes(dVdhV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive', 'size', [n,1]})
dVdTV  = spS.cvS.marginal_value_t(hV, TV);
validateattributes(dVdTV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive', 'size', [n,1]})
vPostponeV = spS.cvS.value_postpone(hV, TV);
validateattributes(vPostponeV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', '<', 0, 'size', [n,1]})

% Marginal value of h
dh = 1e-4;
value2V = spS.cvS.value(hV + dh, TV);
dVdh2V = (value2V - valueV) ./ dh;
checkLH.approx_equal(dVdh2V, dVdhV, 1e-4, []);

% Marginal value of T
dT = 1e-4;
value2V = spS.cvS.value(hV, TV + dT);
dVdT2V = (value2V - valueV) ./ dT;
checkLH.approx_equal(dVdT2V, dVdTV, 1e-4, []);

% Value of postponing
dT = 1e-4;
value2V = spS.cvS.value(hV, TV - dT);
checkLH.approx_equal(vPostponeV,  -spS.r .* valueV - dVdTV,  1e-4, []);
checkLH.approx_equal(vPostponeV,  (value2V .* exp(-spS.r .* dT) - valueV) ./ dT,  1e-4, []);


end