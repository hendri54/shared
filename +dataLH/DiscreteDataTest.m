classdef DiscreteDataTest < matlab.unittest.TestCase
    
properties
   valueV
   inV
   wtV
end
   
properties (TestParameter)
   isWeighted = {false, true}        
end
    
methods (TestMethodSetup)
   function caseSetup(testCase)
      % Setup 
      rng('default');
      nv = 7;
      % Possible values
      testCase.valueV = linspace(-10, 20, nv);
      % Data
      testCase.inV = testCase.valueV(randi(nv, [100, 1]));
      % Weights
      testCase.wtV = rand(size(testCase.inV));                     
   end
end
    

methods (Test)
   function oneTest(testCase, isWeighted)
      dS = dataLH.DiscreteData('weighted', isWeighted);

      dS.value_list(testCase.inV, testCase.wtV);
      assert(isequal(dS.valueV,  unique(testCase.inV)));

      [countV, fracV] = dS.freq_table(testCase.inV, testCase.wtV);

      tbM = dS.formatted_freq_table(testCase.inV, testCase.wtV);
      disp(tbM);
   end
     
end

end