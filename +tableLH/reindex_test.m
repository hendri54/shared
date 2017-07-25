function tests = reindex_test

tests = functiontests(localfunctions);

end

function oneTest(testCase)
   rng('default');
   
   keyListV = unique(randi(1e3, [50, 1]));
   keyListV = keyListV(randperm(length(keyListV)));
   
   keyVar = 'id1';
   
   tbM = table(keyListV(20 : 40),  'VariableNames', {keyVar});
   n = size(tbM, 1);
   tbM.var1 = randi(100, [n, 1]);
   
   tgListV = keyListV(10 : 25);
   
   outM = tableLH.reindex(tbM, keyVar, tgListV);
   
   testCase.verifyEqual(outM.(keyVar), tgListV);
   
   n = length(tgListV);
   for i1 = 1 : n
      idx1 = find(outM.(keyVar)(i1) == tbM.(keyVar));
      if length(idx1) == 1
         assert(outM.var1(i1) == tbM.var1(idx1));
      else
         assert(isempty(idx1));
      end
   end
end