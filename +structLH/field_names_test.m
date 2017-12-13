function tests = field_names_test

tests = functiontests(localfunctions);

end

function oneTest(testCase)
   fCommonV = {'abc'; 'def'; 'ghi'};
   f1V = {'a1'; 'b3'};
   f2V = {'x2'; 'yy4'};
   f3V = {'f99'; 'xc98'};
   fAllV = fCommonV;
   fAllV = union(fAllV, f1V);
   fAllV = union(fAllV, f2V);
   fAllV = union(fAllV, f3V);
   
   rng('default');
   for i1 = 1 : length(f1V)
      s1.(f1V{i1}) = randi(100);
   end
   for i1 = 1 : length(f2V)
      s2.(f2V{i1}) = randi(100);
   end
   for i1 = 1 : length(f3V)
      s3.(f3V{i1}) = randi(100);
   end
   for i1 = 1 : length(fCommonV)
      s1.(fCommonV{i1}) = randi(100);
      s2.(fCommonV{i1}) = randi(100);
      s3.(fCommonV{i1}) = randi(100);
   end
   
   [fCommon2V, fAll2V] = structLH.field_names(s1, s2, s3);
   
   testCase.verifyEqual(fCommon2V, fCommonV);
   testCase.verifyEqual(fAll2V, fAllV);
   
   
   % Call with cell array of struct
   [fCommon2V, fAll2V] = structLH.field_names({s1, s2, s3});
   
   testCase.verifyEqual(fCommon2V, fCommonV);
   testCase.verifyEqual(fAll2V, fAllV);
   
end