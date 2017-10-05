function tests = TableListTest

tests = functiontests(localfunctions);

end

function oneTest(testCase)
   [tbV, vNameV] = table_setup;
   
   tS = tableLH.TableList(tbV{1}, tbV{2}, tbV{3}, tbV{4});
   testCase.verifyEqual(tS.tbV{1}, tbV{1});
   
   vnV = tS.get_var_names;
   testCase.verifyEqual(vnV, sort(vNameV));
   
   classV = tS.get_var_classes;
   testCase.verifyEqual(classV, {'cell', 'cell', 'double'});
   
   
   % Concatenate
   tbM = tS.vertcat;
   
   ir = 0;
   for i1 = 1 : tS.nt
      % Original table
      testTbM = tbV{i1};
      % Returned table
      outTbM = tbM(ir + (1 : size(testTbM,1)), :);
      ir = ir + size(testTbM, 1);
      % Make sure variables that exist in original table are correct
      testCase.verifyEqual(outTbM(:, testTbM.Properties.VariableNames), testTbM);
      % Should also ensure that other variables are blank (so far: visual inspection) +++
   end
end


function cellTest(testCase)
   [tbV, vNameV] = table_setup;
   tS = tableLH.TableList(tbV{1}, tbV{2}, tbV{3}, tbV{4});
   
   for i1 = 1 : length(tbV)
      testCase.verifyEqual(tbV{i1}, tS.tbV{i1});
   end
end


function [tbV, vNameV] = table_setup
   vNameV = {'numberOne', 'charOne', 'charTwo'};
   tbV = cell(4,1);
   tbV{1} = table(randi(6, [7,1]),  'VariableNames', vNameV(1));
   tbV{2} = table({'DDD'; 'EEE'; 'FFF'}, 'VariableNames', vNameV(2));
   tbV{3} = table((1 : 5)', {'a';'b';'c';'de';'fgh'},  'VariableNames', vNameV(1:2));
   tbV{4} = table((11 : 14)',  {'AA'; 'BB';  'CC';  'DD'},  'VariableNames', vNameV([1,3]));
end