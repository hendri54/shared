function regex_escape_test

disp('Testing regex_escape');

%% Underscores

inStr = 'abc_def';
outStr = 'abc\_def';
xStr = stringLH.regex_escape(inStr);
assert(strcmp(xStr, outStr));

xStr = stringLH.regex_escape(xStr);
assert(strcmp(xStr, outStr));


%% Backslashes

inStr = 'abc\def';
outStr = 'abc\\def';
xStr = stringLH.regex_escape(inStr);
assert(strcmp(xStr, outStr));

xStr = stringLH.regex_escape(xStr);
assert(strcmp(xStr, outStr));



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