function tests = close_table_test

tests = functiontests(localfunctions);

end

function oneTest(tS)
   [fid, fPath] = testLH.open_test_file('close_table_test.txt');
   latexLH.close_table(fid);
   
   textS = filesLH.TextFile(fPath);
   lineV = textS.load;
   textS.close;
   
   tS.verifyTrue(strfind(lineV{1}, 'bottomrule') > 0);
end