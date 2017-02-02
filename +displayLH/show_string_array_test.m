function tests = show_string_array_test
   tests = functiontests(localfunctions);
end

function oneTest(testCase)

fprintf('Test show_string_array \n');
dbg = 111;
charWidth = 20;
n = 10;
lenV = round(10 * rand(n,1)) + 1;
inV = cell(n,1);
for i1 = 1 : n
   inV{i1} = repmat(num2str(lenV(i1)), [1, lenV(i1)]);
end

displayLH.show_string_array(inV, charWidth, dbg)

end