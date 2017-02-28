function tests = regex_escape_test
   tests = functiontests(localfunctions);
end


function underscoreTest(testCase)
   %% Underscores

   inStr = 'abc_def';
   outStr = 'abc\_def';
   xStr = stringLH.regex_escape(inStr);
   assert(strcmp(xStr, outStr));

   xStr = stringLH.regex_escape(xStr);
   assert(strcmp(xStr, outStr));
end


function backslTest(testCase)
   %% Backslashes

   inStr = 'abc\def';
   outStr = 'abc\\def';
   xStr = stringLH.regex_escape(inStr);
   assert(strcmp(xStr, outStr));

   xStr = stringLH.regex_escape(xStr);
   assert(strcmp(xStr, outStr));
end

   
function leadingTest(testCase)
   %% Leading Backslashes

   inStr = '\abc\def';
   outStr = '\\abc\\def';
   xStr = stringLH.regex_escape(inStr);
   assert(strcmp(xStr, outStr));

   xStr = stringLH.regex_escape(xStr);
   assert(strcmp(xStr, outStr));
end


function bothTest(testCase)
   %% Both

   inStr = 'abc\def_ghi';
   outStr = 'abc\\def\_ghi';
   xStr = stringLH.regex_escape(inStr);
   assert(strcmp(xStr, outStr));

   xStr = stringLH.regex_escape(xStr);
   assert(strcmp(xStr, outStr));


   % This fails
   % inStr = 'abc\\\_def_ghi';
   % outStr = inStr;
   % xStr = stringLH.regex_escape(inStr);
   % assert(strcmp(xStr, outStr));


end