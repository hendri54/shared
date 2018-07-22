function tests = find_strings_test

tests = functiontests(localfunctions);

end

function oneTest(tS)
   idxV = cellLH.find_strings('abc', {'def', 'abc'});
   tS.verifyEqual(idxV, 2);
   
   idxV = cellLH.find_strings('ab', {'def', 'abc'});
   tS.verifyTrue(isnan(idxV));
   
   idxV = cellLH.find_strings({'abc', 'def', 'ghi'}, {'def', 'abc'});
   tS.verifyEqual(idxV(1), 2);
   tS.verifyEqual(idxV(2), 1);
   tS.verifyTrue(isnan(idxV(3)));
end


