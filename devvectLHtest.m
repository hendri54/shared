function tests = devvectLHtest
   tests = functiontests(localfunctions);
end


function oneTest(testCase)

   fprintf('Testing devvectLH \n');

   nMax = 30;
   v = devvectLH(nMax);

   % add a couple of fields
   modelV = rand(4,1);
   dataV  = rand(size(modelV));
   wtV    = rand(size(modelV));
   ds = devstructLH('nameStr', 'shortStr', 'longStr', modelV, dataV, wtV, 12, '%.1f');

   v.dev_add(ds);

   v.dev_display;

   v.scalar_devs;

   v.dev_by_name('nameStr');
end