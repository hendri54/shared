function tests = NamedListTest

tests = functiontests(localfunctions);

end


function oneTest(testCase)

% Preparation
nMax = 20;
varNameV = cell(nMax, 1);
dataV = cell(nMax, 1);
for i1 = 1 : nMax
   varNameV{i1} = sprintf('var%i', i1);
   dataS = struct;
   dataS.name = varNameV{i1};
   dataS.value = i1;
   dataV{i1} = dataS;
end

% Constructor
vl = mapsLH.NamedList(nMax, 'name');
n = 0;


% Add one
n = n + 1;
vl.add(dataV{n});
assert(vl.exist(dataV{n}.name));

% Try to retrieve something that does not exist
assert(~vl.exist(dataV{n+1}.name));
assert(isempty(vl.retrieve(dataV{n+1}.name)));

% Add group
idxV = n + (1 : 4);
vl.add_group(dataV(idxV));
n = idxV(end);
for i1 = idxV(:)'
   assert(vl.exist(dataV{i1}.name));
   dataOut = vl.retrieve(dataV{i1}.name);
   assert(isequal(dataOut.value,  dataV{i1}.value));
end

end