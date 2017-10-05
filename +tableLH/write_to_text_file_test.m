function tests = write_to_text_file_test

tests = functiontests(localfunctions);

end

function oneTest(testCase)
   tbM = array2table(rand(5,4));
   
   compS = configLH.Computer([]);
   tableLH.write_to_text_file(tbM, fullfile(compS.testFileDir, 'write_to_text_file.txt'));
end