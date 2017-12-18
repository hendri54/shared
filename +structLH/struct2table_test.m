function tests = struct2table_test
% Substantive test requires visual inspection 

tests = functiontests(localfunctions);

end

function oneTest(testCase)
   s1.a = [123.456, 493.2340];
   s1.b = 9872349.3;
   s1.c = 'abc';
   
   s2.b = 444.5566;
   s2.c = 'def';
   s2.g = 98.34;
   
   tbM = structLH.struct2table({s1, s2}, 5, false);
end