function VariableListLHtest

disp('Testing VariableListLH');


% Preparation
nMax = 20;
varNameV = cell(nMax, 1);
for i1 = 1 : nMax
   varNameV{i1} = sprintf('var%i', i1);
end

% Constructor
vl = econLH.VariableListLH(nMax);
n = 0;


% Add one
n = n + 1;
vl.add(varNameV{n});
assert(vl.exist(varNameV{n}));
assert(~vl.exist(varNameV{n+1}));

% Add group
idxV = n + (1 : 4);
vl.add_group(varNameV(idxV));
n = idxV(end);

end