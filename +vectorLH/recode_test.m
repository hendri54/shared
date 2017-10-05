function tests = recode_test

tests = functiontests(localfunctions);

end

function numericTest(testCase)
   dbg = 111;
   vIn = [2 4 6 8];
   searchV = [6 10];
   replaceV = [16, 100];
   otherVal = -99;
   replaceOther = false;
   
   v = vectorLH.recode(vIn, searchV, replaceV, otherVal, replaceOther, dbg);
   
   testCase.verifyEqual(v, [2 4 16 8]);
   
   replaceOther = true;
   v = vectorLH.recode(vIn, searchV, replaceV, otherVal, replaceOther, dbg);   
   testCase.verifyEqual(v, [otherVal, otherVal, 16, otherVal]);
end


%% Replace with cell array
function cellTest(testCase)
   dbg = 111;
   vIn = [2 4 6 8];
   searchV = [6 10];
   replaceV = {'16', '100'};
   otherVal = 'n/a';
   replaceOther = true;
   
   v = vectorLH.recode(vIn, searchV, replaceV, otherVal, replaceOther, dbg);
   
   testCase.verifyEqual(v, {otherVal, otherVal, '16', otherVal});
   
end