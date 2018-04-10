function tests = DependencyListTest

tests = functiontests(localfunctions);

end


%% Initialize with directory
function dirTest(tS)
   compS = configLH.Computer([]);
   inPath = compS.sharedDirV{1};
   dl = filesLH.DependencyList(inPath);
end


%% Initialize with file list
function listTest(tS)
   compS = configLH.Computer([]);

   %  Files must be on path and not in package for `which` to work
   inListV = string({which('errorLH'), which('devvectLH')});
   dl = filesLH.DependencyList(inListV);
   listV = dl.dependencies;
   tS.verifyTrue(~isempty(listV));
   tS.verifyTrue(isa(listV, 'cell'));
   existV = logical(size(listV));
   for i1 = 1 : length(listV)
      existV(i1) = exist(listV{i1}, 'file') > 0;
   end
   tS.verifyTrue(all(existV));

   % Back up to zip file
   zipFile = fullfile(compS.testFileDir,  'DependencyListTest.zip');
   if exist(zipFile, 'file')
      delete(zipFile);
   end
   dl.back_up_zip(zipFile,  true);
   tS.verifyTrue(exist(zipFile, 'file') > 0);
   
   % Copy dependencies to new dir
   overWrite = true;
   srcDir = fileparts(inListV{1});
   tgDir = fullfile(compS.testFileDir, 'DependencyList');
   for dryRun = [true, false]
      dl.copy_dependencies(listV,  srcDir, tgDir, overWrite, dryRun);
   end
end