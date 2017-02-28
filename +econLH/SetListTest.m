function tests = SetListTest

tests = functiontests(localfunctions);

end



function oneTest(testCase)
   nameV = {'default', 'other', 'another', 'fourth'};
   numberV = uint64([1, 4, 98, 32]);
   otherV = {'defaultOther', 'otherOther', 'anotherOther', 'fourthOther'};
   
   name2V = {'addOne', 'addTwo'};
   number2V = [11, 22];
   other2V = {'otherOne', 'other2'};
   
   nMax = 20;
   sS = econLH.SetList(nMax);
   sS.add(nameV, numberV, otherV);
   assert(sS.n == length(nameV));
   
   sS.add(name2V, number2V, other2V);
   assert(sS.n == length(nameV) + length(name2V));
   
   assert(all(sS.exists_name(nameV)));
   assert(all(sS.exists_name(name2V)));
   assert(all(sS.exists(nameV)));
   assert(~sS.exists_name('not'))
   
   assert(all(sS.exists_number(numberV)));
   assert(all(sS.exists(numberV)));
   assert(~sS.exists_number(44));
   
   for i1 = 1 : length(nameV)
      [nameOut, numberOut, otherOut] = sS.retrieve_name(nameV{i1});     
      assert(isequal(nameOut,  string(nameV{i1})));
      assert(isequal(numberOut,  numberV(i1)));
      assert(isequal(otherOut,  otherV{i1}));
      
      [nameOut, numberOut, otherOut] = sS.retrieve_number(numberV(i1));     
      assert(isequal(numberOut, numberV(i1)));

      [nameOut, numberOut, otherOut] = sS.retrieve(numberV(i1));     
      assert(isequal(numberOut, numberV(i1)));
      [nameOut, numberOut, otherOut] = sS.retrieve(nameV(i1));     
      assert(isequal(numberOut, numberV(i1)));
   end

end