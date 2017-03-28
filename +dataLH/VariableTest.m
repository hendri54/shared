function tests = VariableTest

tests = functiontests(localfunctions);

end

function oneTest(testCase)

otherV = {'other1', 'val1',  'other2', 'val2'};
vS = dataLH.Variable('test1', 'minVal', 1, 'maxVal', 99, 'missValCodeV', [98, 99], 'otherV', otherV);

val1 = vS.other('other1');
assert(strcmp(val1, 'val1'));

end