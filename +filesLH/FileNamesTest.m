function tests = FileNamesTest

tests = functiontests(localfunctions);

end


function fnTest(testCase)
   fnListV = {'const_lh.m',  '/Users/lutz/test1.txt'};
   fS = filesLH.FileNames(fnListV);
   newListV = fS.append_date;
   assert(isa(newListV, 'string'));
   assert(isequal(size(newListV),  size(fnListV)));
end


%% Test appending dir
function dir_test(testCase)
   dirName = 'test92';
   fnListV = {'const_lh.m',  '/Users/lutz/test1.txt'};
   tgListV = string({fullfile(dirName, fnListV{1}),  fullfile('/Users/lutz', dirName, 'test1.txt')});
   
   fS = filesLH.FileNames(fnListV);
   newListV = fS.append_dir(dirName);
   assert(isa(newListV, 'string'));
   assert(isequal(newListV, tgListV));


end