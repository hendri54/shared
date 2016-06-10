function show_test

testS.test1 = 123;
testS.testV = linspace(1, 2, 4);
testS.testM = linspace(1, 2, 3)' * linspace(1, 2, 4);
testS.testString = 'show this';
testS.not = 'do not show this';

structLH.show(testS, 'test')

end