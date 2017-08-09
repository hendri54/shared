function tests = SpssTest

tests = functiontests(localfunctions);

end

function parseTest(testCase)

   spS = statsLH.Spss;
   
   lineV = {' 07 ''abc def''',  '  9985  ''ghi klm''',  '302  ''abc''def'''};
   [valueV, labelV] = parse_value_labels(spS, lineV);
   testCase.verifyEqual(valueV, [7; 9985; 302]);
   testCase.verifyEqual(labelV,  {'abc def';  'ghi klm';  'abc''def'});
   
   % Same with double quotes
   lineV = {' 07 "abc def"',  '  9985  "ghi klm"'};
   [valueV, labelV] = parse_value_labels(spS, lineV);
   testCase.verifyEqual(valueV, [7; 9985]);
   testCase.verifyEqual(labelV,  {'abc def';  'ghi klm'});
end


%% Read value labels; IPUMS syntax
function readValueLabelsAltTest(testCase)
   spS = statsLH.Spss;
   compS = configLH.Computer([]);
   [valueV, labelV] = spS.read_value_labels('school', fullfile(compS.testFileDir, 'spss', 'codebook2.sps'));
   testCase.verifyEqual(valueV, [0; 1; 2; 3; 4; 9]);
   testCase.verifyEqual(labelV{1}, 'NIU (not in universe)');
   testCase.verifyEqual(labelV{6}, 'Unknown/missing');
end


%% Read value labels; single quotes syntax
function readValueLabelsTest(testCase)
   spS = statsLH.Spss;
   compS = configLH.Computer([]);
   [valueV, labelV] = spS.read_value_labels('school', fullfile(compS.testFileDir, 'spss', 'codebook.sps'));
   testCase.verifyEqual(valueV, [0, 1, 2, 9]');
   testCase.verifyEqual(labelV,  {'N/A';  'No, not in school';  'Yes, in school';  'Missing'});
end