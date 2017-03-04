function tests = VariableListLHtest

tests = functiontests(localfunctions);

end

function stringTest(testCase)
   oneCase('string');
end


%% Run one test
function oneCase(cellOrString)

% Preparation
nMax = 20;
varNameV = cell(nMax, 1);
descrV = cell(nMax, 1);
for i1 = 1 : nMax
   varNameV{i1} = sprintf('var%i', i1);
   descrV{i1} = sprintf('d%i', i1);
end

if strcmp(cellOrString, 'string')
   varNameV = string(varNameV);
   descrV = string(descrV);
end

% Constructor
vl = econLH.VariableListLH(nMax);
n = 0;


% Add one
n = n + 1;
vl.add(varNameV{n}, descrV{n});
assert(vl.exist(varNameV{n}));
assert(~vl.exist(varNameV{n+1}));

% Add group
idxV = n + (1 : 4);
vl.add_group(varNameV(idxV));
n = idxV(end);

idxV = n + (1 : 3);
vl.add_group(varNameV(idxV), descrV(idxV));
n = idxV(end);

end