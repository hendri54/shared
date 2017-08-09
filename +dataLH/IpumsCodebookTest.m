function tests = IpumsCodebookTest

tests = functiontests(localfunctions);

end


function cbS = objSetup
   currDir = fileparts(mfilename('fullpath'));
   testFile = fullfile(currDir,  'test_files',  'codes_occ.txt');
   
   cbS = dataLH.IpumsCodebook(testFile);
end


function oneTest(testCase)
   cbS = objSetup;
   lineV = cbS.load;
   
end


function lineTypeTest(testCase)
   cbS = objSetup;
   
   assert(isequal(cbS.line_type('BR'),  'country'));
   assert(isequal(cbS.line_type('1995'),  'year'));
   assert(isequal(cbS.line_type('MEMBERS OF THE ARMED FORCES'),  'header'));
   assert(isequal(cbS.line_type('3222	Technicians and nurses'' aides	22,901'),  'regular'));
end


%% Parse regular line
function parseTest(testCase)
   cbS = objSetup;
   
   lineStr = '3222	Technicians and nurses'' aides	22,901';
   [codeOut, descrOut, countOut] = cbS.parse_regular_line(lineStr);
   
   testCase.verifyEqual(codeOut, 3222);
   testCase.verifyEqual(descrOut, 'Technicians and nurses'' aides');
   testCase.verifyEqual(countOut, 22901);
end


%% Read entire codebook
function readTest(testCase)
   cbS = objSetup;
   
   overWrite = true;
   outDir = fileparts(cbS.fn);
   outFn = fullfile(outDir, 'readTest.xlsx');
   cbS.write_to_file(outFn, overWrite);

end