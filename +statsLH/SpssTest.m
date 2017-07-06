function tests = SpssTest

tests = functiontests(localfunctions);

end

function oneTest(testCase)
   spS = statsLH.Spss;
   
   lineV = {' 07 ''abc def''',  '  9985  ''ghi klm'''};
   [valueV, labelV] = parse_value_labels(spS, lineV);
   testCase.verifyEqual(valueV, [7; 9985]);
   testCase.verifyEqual(labelV,  {'abc def';  'ghi klm'});
   
   lhS = const_lh;
   [valueV, labelV] = spS.read_value_labels('school', fullfile(lhS.dirS.testFileDir, 'spss', 'codebook.sps'));
   testCase.verifyEqual(valueV, [0; 1; 2; 9]);
   testCase.verifyEqual(labelV, {'N/A';  'No, not in school';  'Yes, in school';  'Missing'});

end