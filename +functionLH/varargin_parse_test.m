function tests = varargin_parse_test

tests = functiontests(localfunctions);

end

function oneTest(testCase)
   nameV = {'a1', 'bTwo', 'cThree'};
   valueV = {123,  'abc',  [994.0, 12.8]};
   
   inputV = cell([2 * length(nameV), 1]);
   j = 0;
   for i1 = 1 : length(nameV)
      j = j + 1;
      inputV{j} = nameV{i1};
      j = j + 1;
      inputV{j} = valueV{i1};
   end
   
   x = functionLH.varargin_parse_test_class;
   functionLH.varargin_parse(x, inputV);
   
   for i1 = 1 : length(nameV)
      nameStr = nameV{i1};
      assert(isequal(x.(nameStr),  valueV{i1}));
   end
end