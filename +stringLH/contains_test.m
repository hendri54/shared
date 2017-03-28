function tests = contains_test

tests = functiontests(localfunctions);

end


function oneTest(testCase)

dbg = 111;

inStr = 'abc\d/e\_f.gh';

out1 = stringLH.contains(inStr, {inStr(3:5), 'xyc', 'zzd'}, dbg);
assert(out1);

out1 = stringLH.contains(inStr, {'xyc', 'zzd'}, dbg);
assert(~out1);

out1 = stringLH.contains(inStr, [inStr(3), 'zzxy'], dbg);
assert(out1);

out1 = stringLH.contains(inStr, 'zzxy', dbg);
assert(~out1);



end