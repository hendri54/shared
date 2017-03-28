function tests = string_array_to_cell_test

tests = functiontests(localfunctions);

end


function oneTest(testCase)

cellV = {'abc', 'defg'};
strV = string(cellV);

cell2V = stringLH.string_array_to_cell(strV);

assert(isequal(cellV, cell2V));

end