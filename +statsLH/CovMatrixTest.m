function tests = CovMatrixTest

tests = functiontests(localfunctions);

end


function oneTest(testCase)

n = 5;
varNameV = stringLH.vector_to_string_array(1 : n,  'var%i');
cM = statsLH.CovMatrix(randn(5,5) + eye(5), varNameV);

disp(cM.cell_array('%.2f'))

end