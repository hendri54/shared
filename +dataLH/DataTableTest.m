classdef DataTableTest < matlab.unittest.TestCase
    
%    properties (TestParameter)
%               
%    end
%     
%    methods (TestMethodSetup)
%       function x(testCase)
%                      
%       end
%    end
%     
%    methods (TestMethodTeardown)
%       function y(testCase)
%                      
%       end
%    end
    
methods (Test)
   function oneTest(testCase)
      rng('default');
      n = 40;
      tbM = table;
      
      % Continuous
      age = dataLH.Variable('age', 'vClass', 'double',  'minVal', 0,  'maxVal', 99,  'missValCodeV', NaN);
      tbM.age = rand([n, 1]) .* 80;
      tbM.age([20, 30]) = NaN;
      
      % Logical
      male = dataLH.Variable('male', 'vClass', 'logical');
      tbM.male = (rand([n,1]) > 0.6);
      
      % Discrete
      vSize = dataLH.Variable('size', 'vClass', 'uint16',  'validValueV', uint16([2,4,6]), 'missValCodeV', uint16(0));
      valueV = uint16(0:2:6)';
      tbM.size = valueV(randi(length(valueV), [n,1]));
      
      dS = dataLH.DataTable(tbM, {age, male, vSize});      
      [xV, varS] = dS.retrieve('male');
      assert(isequal(xV, tbM.male));
      assert(isequal(varS.nameStr, 'male'));
      
      
      % Add variable
      vAdd = dataLH.Variable('added', 'vClass', 'double');
      added = randn([n, 1]);
      dS.add_variable(added, vAdd);
      
      outM = dS.summary_tb_continuous
      outM = dS.summary_tb_logical
      
      
      % Drop variable
      dS.drop_variable('added');
      assert(isempty(dS.retrieve('added')));
   end

end
end