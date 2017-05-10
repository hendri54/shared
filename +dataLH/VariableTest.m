classdef VariableTest < matlab.unittest.TestCase
   
properties
   vS  dataLH.Variable
end
    
properties (TestParameter)
   isDiscrete = {false, true}
end
    
methods (TestMethodSetup)
   function setupData(testCase)
      otherV = {'other1', 'val1',  'other2', 'val2'};
      testCase.vS = dataLH.Variable('test1', 'minVal', 1, 'maxVal', 99, 'missValCodeV', [98, 99], 'otherV', otherV);
   end
end
    

methods (Test)
   %% Basics
   function oneTest (testCase)
      val1 = testCase.vS.other('other1');
      assert(strcmp(val1, 'val1'));
   end
   
   
   %% Input data checking
   function inputTest(testCase, isDiscrete)
      rng('default');
      testCase.vS.isDiscrete = isDiscrete;

      if isDiscrete
         testCase.vS.validValueV = randi(100, [10, 1]);
         n = length(testCase.vS.validValueV);
         inV = testCase.vS.validValueV(randi(n, [20, 1]));
      else
         inV = testCase.vS.minVal + rand(20, 1) .* (testCase.vS.maxVal - testCase.vS.minVal);
      end
      
      inV(10) = testCase.vS.missValCodeV(1);
      
      [out1, outMsg] = is_valid(testCase.vS, inV);
      testCase.verifyEqual(out1, true);
      
      testCase.vS.replace_missing_values(inV);
      
      testCase.vS.process(inV);
   end
     
end

end