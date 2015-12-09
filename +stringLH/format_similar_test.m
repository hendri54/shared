function format_similar_test

disp('Testing format_similar');
dbg = 111;

inStr = '123.456';
inNumber = 9.1234;
outStr = stringLH.format_similar(inStr, inNumber, dbg);
assert(strcmp(outStr, '9.123'));

% No decimal places
outStr = stringLH.format_similar('123', 9.2, dbg);
assert(strcmp(outStr, '9'));

% Scientific notation
outStr = stringLH.format_similar('1.23e-4', 0.1234e-4, dbg);
assert(strcmp(outStr, '1.23e-05'));

end