function tests = deal_test

tests = functiontests(localfunctions);

end

function oneTest(tS)
   x = 4 : 6;
   [a,b,c] = vectorLH.deal(x);
   tS.verifyEqual(a, 4);
   tS.verifyEqual([a,b,c], x);
end