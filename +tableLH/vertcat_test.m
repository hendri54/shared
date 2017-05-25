function tests = vertcat_test

tests = functiontests(localfunctions);

end

function oneTest(testCase)
   rng('default');
   
   % Common variables
   varNameV = {'a1', 'b2', 'c3', 'd4'};
   classV  = {'double', 'uint16', 'char', 'double'};
   nt = 3;
   nV = round(linspace(5, 10, nt))';
   
   % Make tables
   tbV = cell(nt, 1);
   for i1 = 1 : nt
      n = nV(i1);
      tbM = table(rand([n,1], classV{1}),  randi(10, [n,1], classV{2}),  char_array(n),  ...
         rand([n,1]),  'VariableNames', varNameV);
      % Add another variable
      tbM.(sprintf('x%i',  i1)) = rand([n,1]);
      tbV{i1} = tbM;
   end
   
   tbM = tableLH.vertcat(tbV, []);
   testCase.verifyEqual(tbM.Properties.VariableNames, varNameV);
   
   % Check values
   endIdxV = cumsum(nV);
   startIdxV = [1; endIdxV + 1];
   for i1 = 1 : nt
      for iVar = 1 : length(varNameV)
         varName = varNameV{i1};
         testCase.verifyEqual(tbM.(varName)(startIdxV(i1) : endIdxV(i1)),  tbV{i1}.(varName));
      end
   end
end



% Generate cell array of characters for testing
function outV = char_array(n)
   charV = 'abcdefghiklmnopqrstuvwxyz';
   outV = cell(n, 1);
   for i1 = 1 : n
      % Length
      l = randi(8, [1,1]);
      % Random character permutation
      idxV = randperm(length(charV));
      outV{i1} = charV(idxV(1 : l));
   end

end