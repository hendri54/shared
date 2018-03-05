function tests = DataByYearTest

tests = functiontests(localfunctions);

end


function oneTest(testCase)

% Make a table
yearV = 1950 : 2 : 2000;
x1V = linspace(1, 2, length(yearV))';
x2V = linspace(4, 2, length(yearV))';

tbM = table(yearV(:), x1V(:), x2V(:), 'VariableNames', {'year', 'x1', 'x2'});

dS = dataLH.DataByYear(tbM);

year1 = yearV(3);
yrIdx = dS.year_range(year1);
if yrIdx ~= 3
   error('Invalid');
end

varIdx = dS.var_columns('x1');
if varIdx ~= 2
   error('Invalid');
end


% Retrieve
% With repeated years
yrIdxV = [2 : 2 : 10, 2 : 2 : 10];
outYearV = yearV(yrIdxV);
outM = dS.retrieve('x1', outYearV);
testCase.verifyEqual(outM,  x1V(yrIdxV))

outM = dS.retrieve({'x2', 'x1'}, outYearV);
testCase.verifyEqual(outM,  [x2V(yrIdxV), x1V(yrIdxV)]);

end