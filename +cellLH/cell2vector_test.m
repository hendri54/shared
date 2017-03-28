function tests = cell2vector_test

tests = functiontests(localfunctions);

end

function oneTest(testCase)

dbg = 111;

trueV = [];

% Make cell array
sizeV = [4, 3, 2];
cellM = cell(sizeV);
n = prod(sizeV);
for i1 = 1 : n
   cDim = round(3 * rand(1,1));
   if cDim == 0
      cellM{i1} = [];
   else
      cSizeV = round(2 + 2 * rand(1, cDim));
      xM = randn(cSizeV);
      cellM{i1} = xM;
      trueV = [trueV; xM(:)];
   end
end

% Extract all elements
outV = cellLH.cell2vector(cellM, dbg);

checkLH.approx_equal(outV, trueV, 1e-8, []);

end