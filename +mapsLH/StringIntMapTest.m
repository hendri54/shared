function tests = StringIntMapTest

tests = functiontests(localfunctions);

end

function AllTest(testCase)
   nameV = {'name1', 'name3', 'name2'};
   setV  = [1, 3, 2];
   sS = mapsLH.StringIntMap(nameV, setV);
   
   % All values and keys
   [kOutV, vOutV] = all_keys_values(sS);
   % Need to sort because order of output is not determined
   assert(isequal(sort(kOutV),  sort(nameV)));
   assert(isequal(sort(vOutV),  sort(setV)));
   
   % Values from keys
   outV = sS.values(nameV([1,3]));
   assert(isequal(outV,  setV([1,3])));
   
   % Keys from values
   outV = sS.keys(setV([1,3]));
   assert(isequal(outV,  nameV([1,3])));
   
   outV = sS.keys(setV(2));
   assert(isequal(outV{1}, nameV{2}));
   
   % Add values
   name2V = {'new1', 'new3'};
   set2V   = [11, 13];
   sS.add(name2V, set2V);
   
   outV = sS.keys([setV(1), set2V(1)]);
   assert(isequal(outV,  {nameV{1},  name2V{1}}));
   
   % Do keys match values?
   assert(sS.matches(nameV, setV) == true);
   assert(sS.matches(nameV(1:2), setV(2:3)) == false);
end