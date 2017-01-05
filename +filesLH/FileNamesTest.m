function tests = FileNamesTest

tests = functiontests(localfunctions);

end


function fnTest(testCase)
   fnListV = {'const_lh.m',  '/Users/lutz/test1.txt'};
   fS = filesLH.FileNames(fnListV);
   newListV = fS.append_date;
   assert(isa(newListV, 'cell'));
   assert(isequal(size(newListV),  size(fnListV)));
end