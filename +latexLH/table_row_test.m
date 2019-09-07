function tests = table_row_test

tests = functiontests(localfunctions);

end

function oneTest(tS)
   dataV = ["abd def", "123,456.89"];
   outStr = latexLH.table_row(dataV);
   tS.verifyEqual(outStr, char(dataV(1) + " & " + dataV(2) + " \\"));
end


function heatTest(tS)
   dataV = ["abd def", "123,456.89"];
   heatV = [NaN, 15];
   outStr = latexLH.table_row(dataV, heatV);
   tS.verifyEqual(outStr, char(dataV(1) + " & \cellcolor{blue!15}" + dataV(2) + " \\"));
end