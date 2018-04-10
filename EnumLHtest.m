function tests = EnumLHtest
   tests = functiontests(localfunctions);
end


function oneTest(tS)

   valueList = {'v1', 'v2', 'v3'};
   value1 = 'v2';

   x = EnumLH(value1, valueList);

   assert(x.equals(value1));
   assert(~x.equals(valueList{1}));

   x.set(valueList{1});

   assert(x.is_valid(valueList{3}));
   assert(~x.is_valid('v9'));

end