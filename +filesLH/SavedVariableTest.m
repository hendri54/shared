function tests = SavedVariableTest

tests = functiontests(localfunctions);

end

function oneTest(testCase)
   vS = filesLH.SavedVariableTestClass;
   
   % Get a valid variable name
   varName = vS.varListV{1};
   setName = 'setTest';
   
   saveM = magic(3);
   
   vS.save(saveM, varName, setName);
   
   fn = vS.var_fn(varName, setName);
   testCase.verifyTrue(exist(fn, 'file') > 0,  'File was not created');
   
   % Load and check result
   loadM = vS.load(varName, setName);
   
   testCase.verifyEqual(loadM, saveM);
end