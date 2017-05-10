classdef MatrixTest < matlab.unittest.TestCase

properties
   sizeV  
   mM  double
   mS  matrixLH.Matrix
end


properties (MethodSetupParameter)
   % Test for two and 3 dim matrices
   nDimensions = {2, 3};
end
 
   

methods (TestMethodSetup)
   function makeMatrix(testCase, nDimensions)
      sizeVector = [5, 3, 4, 6, 2];
      testCase.sizeV = sizeVector(1 : nDimensions);
         
      rng(43);
      testCase.mM = 5 * randn(testCase.sizeV);

      testCase.mS = matrixLH.Matrix(testCase.mM);
   end
end

methods (Test)

%% Test indexing
function indexTest(testCase)
   % Only implemented for up to 3D matrix
   if length(testCase.sizeV) > 3
      return
   end
   
   nd = length(testCase.sizeV);
   
   indexV = {2 : testCase.sizeV(1), testCase.mS.all, 2};
   resultV = {indexV{1},  1 : testCase.sizeV(2),  indexV{3}};
   outV = testCase.mS.make_index(indexV(1 : nd));
   for i1 = 1 : nd
      testCase.verifyEqual(outV{i1}, resultV{i1});
   end

   indexV = {{1, 3}, {testCase.mS.last, 1}, 1};
   resultV = {1:3,  testCase.sizeV(2) : -1 : 1,  indexV{3}};
   outV = testCase.mS.make_index(indexV(1 : nd));
   for i1 = 1 : nd
      testCase.verifyEqual(outV{i1}, resultV{i1});
   end

   % Try an invalid index
   indexV = {2 : 9, 2, 1};
   try 
      testCase.mS.make_index(indexV(1 : nd));
      error('Error not caught');
   catch
      % Error as expected
   end

end


%% Test getting elements
function getTest(testCase)
   nd = length(testCase.sizeV);
   
   if nd ~= 3
      return;
   end
   
   indexV = {2,3,1};
   outM = testCase.mS.getindex(indexV);
   if ~isequal(outM, testCase.mM(2,3,1))
      error('Invalid');
   end

   indexV = {{2, testCase.mS.last}, testCase.mS.all, 2};
   outM = testCase.mS.getindex(indexV);
   if ~isequal(outM, testCase.mM(2:end, :, 2))
      error('Invalid');
   end
end


%% Test putting elements
function putTest(testCase)
   nd = length(testCase.sizeV);
   
   indexV = {2, 2:3, 1:2, 4:6};
   dimV = [1, 2, 2, 3];
   indexV = indexV(1 : nd);
   dimV = dimV(1 : nd);
   
   rng('default')
   inM = randn(dimV);
   testCase.mS.setindex(inM, indexV);
   testCase.verifyEqual(testCase.mS.mM(indexV{:}), inM)

   testCase.mS.set(single(testCase.mM));
   testCase.mS.validate;

end

%% Matrix operations
function operTest(testCase)
   testCase.mS.set(testCase.mM);
   inM = 3 * rand(testCase.sizeV);
   testCase.mS.oper(inM, testCase.mS.plus);

   maxDiff = max(abs(testCase.mS.mM - (testCase.mM + inM)));
   if maxDiff > 1e-8
      disp(maxDiff);
      error('Invalid');
   end

   testCase.mS.oper(inM, testCase.mS.minus);
   if max(abs(testCase.mS.mM - testCase.mM)) > 1e-8
      error('Invalid');
   end

   m2S = matrixLH.Matrix(testCase.mM, testCase.mS.missVal);
   outM = m2S.operOut(inM, testCase.mS.minus);
   checkLH.approx_equal(outM,  testCase.mM - inM, 1e-8, []);

   testCase.mS.add(inM);
   if max(abs(testCase.mS.mM - (testCase.mM + inM))) > 1e-8
      error('Invalid');
   end

   testCase.mS.set(testCase.mM);
   testCase.mS.oper(2, testCase.mS.times);
   testCase.mS.oper(2, testCase.mS.divide);
   if max(abs(testCase.mS.mM - testCase.mM)) > 1e-8
      error('Invalid');
   end
end


%% Add vectors and scalars
function vectorTest(testCase)
   if length(testCase.sizeV) ~= 2
      return
   end
   
   rng(43);
   testCase.mM = 5 * randn(testCase.sizeV);

   testCase.mS.set(testCase.mM);
   rowVecIn = rand([1, testCase.sizeV(2)]);
   testCase.mS.add_vector(rowVecIn);
   checkLH.approx_equal(testCase.mS.mM,  testCase.mM + repmat(rowVecIn, [testCase.sizeV(1), 1]),  1e-8, []);

   testCase.mS.set(testCase.mM);
   colVecIn = rand([testCase.sizeV(1), 1]);
   testCase.mS.add_vector(colVecIn);
   checkLH.approx_equal(testCase.mS.mM,  testCase.mM + repmat(colVecIn, [1, testCase.sizeV(2)]),  1e-8, []);
end



%% Formatting
function formatTest(testCase)
   for i1 = 1 : 3
      if i1 == 1
         colOrRowStr = 'col';
         n = 1;
      elseif i1 == 2
         colOrRowStr = 'col';
         n = testCase.sizeV(2);
      elseif i1 == 3
         n = testCase.sizeV(1);
         colOrRowStr = 'row';
      else 
         error('Invalid');
      end

      if n == 1
         fmtStrV = '%.2f';
      else
         fmtStrV = cell(n, 1);
         for j = 1 : n
            fmtStrV{j} = ['%.', sprintf('%i', j), 'f'];
         end
      end

      outM = testCase.mS.formatted_cell_array(fmtStrV, colOrRowStr);
   end
end

end
end