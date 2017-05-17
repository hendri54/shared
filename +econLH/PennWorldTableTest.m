classdef PennWorldTableTest < matlab.unittest.TestCase
    
   properties (TestParameter)
      verNum = {8.1};        
   end
    
%    methods (TestMethodSetup)
%       function x(testCase)
%                      
%       end
%    end
    
    
   methods (Test)
      function oneTest(testCase, verNum)
         pS = econLH.PennWorldTable(verNum);
         pS.var_fn('test');
         
         saveM = rand(4,3);
         pS.var_save(saveM, 'test');
         loadM = pS.var_load('test');
         testCase.verifyEqual(saveM, loadM);
         
         pS.make_table(false);
         m = pS.load_table;
         
         xV = pS.load_var_country('pop', 'USA');
         testCase.verifyTrue(abs(xV(1) - 155.5472) < 1);
      end
      
   end
end