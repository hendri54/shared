function tests = VarListTest

tests = functiontests(localfunctions);

end


function oneTest(testCase)
   test1 = dataLH.Variable('test1', 'vClass', 'uint16');
   test2 = dataLH.Variable('test2', 'vClass', 'logical');
   test3 = dataLH.Variable('test3', 'vClass', 'uint16',  'isDiscrete', true);
   
   vlS = dataLH.VarList({test1, test2, test3});
   vlS.names;
   assert(isequal(vlS.nVars, 3));
   
   % Find a variable by name
   vIdx = vlS.find_by_name('test1');
   assert(~isempty(vIdx));
   vIdx = vlS.find_by_name('notthere');
   assert(isempty(vIdx));
   varS = vlS.retrieve('test1');
   
   % Add a variable
   addList = {dataLH.Variable('age', 'vClass', 'double')};
   vlS.add_variables(addList);
   vIdx = vlS.find_by_name('age');
   assert(~isempty(vIdx));
   
   
   vIdxV = vlS.find_variables('logical');
   for i1 = vIdxV(:)'
      varS = vlS.listV{i1};
      assert(isequal(varS.vClass, 'logical'));
   end
   
   vIdxV = vlS.find_variables('discrete');
   for i1 = vIdxV(:)'
      varS = vlS.listV{i1};
      assert(varS.isDiscrete);
   end
   
   vIdxV = vlS.find_variables('continuous');
   for i1 = vIdxV(:)'
      varS = vlS.listV{i1};
      assert(~varS.isDiscrete  &  ~isequal(varS.vClass, 'logical'));
   end
   
   
   % Drop variables
   n = vlS.nVars;
   vlS.drop_variables({'test1'});
   assert(isequal(vlS.nVars, n-1));
   assert(isempty(vlS.find_by_name('test1')));
end