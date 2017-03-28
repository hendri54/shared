function tests = show_test

tests = functiontests(localfunctions);

end


function oneTest(testCase)

testS.test1 = 123;
testS.testV = linspace(1, 2, 4);
testS.testM = linspace(1, 2, 3)' * linspace(1, 2, 4);
testS.testString = 'show this';
testS.not = 'do not show this';

structLH.show(testS, 'test')

end