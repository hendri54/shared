function tests = compare_test

tests = functiontests(localfunctions);

end

function oneTest(testCase)
   dbg = 111;
   
   % Make structures
   f1V = {'a1', 'b1', 'c1'};
   f2V = {'a2', 'b2'};
   fBothV = {'a12', 'b12', 'c12', 'd12'};
   
   s1 = struct;
   s2 = struct;
   for i1 = 1 : length(f1V)
      s1.(f1V{i1}) = i1;
   end
   for i1 = 1 : length(f2V)
      s2.(f2V{i1}) = i1;
   end
   for i1 = 1 : length(fBothV)
      s1.(fBothV{i1}) = i1;
      s2.(fBothV{i1}) = i1 + 1;
   end

   % Test
   structLH.compare(s1, s2, dbg);
end