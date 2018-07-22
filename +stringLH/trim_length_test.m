function tests = trim_length_test

tests = functiontests(localfunctions);

end

function oneTest(tS)
   maxLen = 5;
   
   strV = ["abc", "defg", "hijkl"];
   outV = stringLH.trim_length(strV, maxLen);
   tS.verifyEqual(strV, outV);
   
   str2V = strV;
   str2V(3) = strcat(strV(3), "added");
   outV = stringLH.trim_length(str2V, maxLen);
   tS.verifyEqual(strV, outV);
   
   cellV = cellstr(str2V);
   outV = stringLH.trim_length(cellV, maxLen);
   tS.verifyEqual(cellstr(strV), outV);
   
end