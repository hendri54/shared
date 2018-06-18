function tests = table_row_test

tests = functiontests(localfunctions);

end

function oneTest(tS)
   dataV = ["abd def", "123,456.89"];
   outStr = latexLH.table_row(dataV);
   tS.verifyEqual(outStr, char(dataV(1) + " & " + dataV(2) + " \\"));
end