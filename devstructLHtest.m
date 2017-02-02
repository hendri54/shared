function tests = devstructLHtest
   tests = functiontests(localfunctions);
end

function oneTest(testCase)

modelV = rand(4,1);
dataV  = rand(size(modelV));
wtV = rand(size(modelV));
scaleFactor = 1.2;
fmtStr = '%.2f';

d = devstructLH('name', 'shortStr', 'longStr', modelV, dataV, wtV, scaleFactor, fmtStr);

d.scalar_dev;

d.short_display;

end