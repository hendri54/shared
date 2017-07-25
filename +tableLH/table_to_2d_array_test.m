function tests = table_to_2d_array_test

tests = functiontests(localfunctions);

end

function oneTest(testCase)
   tbM = make_table;
   
   varNameV = {'v1', 'v3'};
   
   [outS, id1V, id2V] = tableLH.table_to_2d_array(tbM, 'x', 'y', varNameV);
   
   % Test that the values are correct
   for iv = 1 : length(varNameV)
      outM = outS.(varNameV{iv});
      for ir = 1 : size(tbM, 1)
         i1 = find(tbM.x(ir) == id1V);
         i2 = find(tbM.y(ir) == id2V);
         assert(isequal(outM(i1, i2), tbM.(varNameV{iv})(ir)));
      end
   end
end


%% Make table for testing
% Each (x,y) combination must be unique, but not all need occur
function tbM = make_table
   rng('default');
   xV = 2 : 2 : 12;
   n1 = length(xV);
   yV = 14 : -3 : 4;
   n2 = length(yV);
   
   n = n1 * n2;
   id1V = zeros(n, 1);
   id2V = zeros(n, 1);
   ir = 0;
   for i1 = 1 : n1
      idxV = ir + (1 : n2);
      id1V(idxV) = xV(i1);
      id2V(idxV) = yV;
      ir = ir + n2;
   end
   
   % Randomly shuffle table
   idxV = randperm(n);
   tbM = table(id1V(idxV), id2V(idxV), 'VariableNames', {'x', 'y'});
   
   % Make sure each (x,y) combination is unique
   
   
   nv = 4;
   for iv = 1 : nv
      tbM.(sprintf('v%i', iv)) = randi(100, [n, 1]);
   end
end