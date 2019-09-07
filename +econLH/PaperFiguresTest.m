function tests= PaperFiguresTest

tests = functiontests(localfunctions);

end


function oneTest(tS)
% Change: did not test sub dirs
   compS = configLH.Computer([]);
   srcDefaultDir = compS.testFileDir;
   tgDefaultDir  = compS.testFileDir2;
   n = 25;

   pS = econLH.PaperFigures(srcDefaultDir, tgDefaultDir, n);

   idx = 1;
   pS.add('abc.pdf', [], []);
   fileS = pS.fileListV{idx};
   tS.verifyTrue(strcmp(fileS.srcPath,  fullfile(srcDefaultDir, 'abc.pdf')));
   tS.verifyTrue(strcmp(fileS.tgPath,   fullfile(tgDefaultDir,  'abc.pdf')));

   idx = idx + 1;
   srcPath = fullfile(srcDefaultDir, 'test1.tex');
   pS.add('test1.tex', 'new1.tex', []);
   fileS = pS.fileListV{idx};
   tS.verifyTrue(strcmp(fileS.srcPath,  srcPath));
   tS.verifyTrue(strcmp(fileS.tgPath,   fullfile(tgDefaultDir,  'new1.tex')));

   idx = idx + 1;
   srcPath = fullfile(compS.baseDir, 'test2.tex');
   tgPath  = fullfile(tgDefaultDir, 'test2', 'new2.tex');
   pS.add(srcPath, 'new2.tex', 'test2');
   fileS = pS.fileListV{idx};
   tS.verifyTrue(strcmp(fileS.srcPath,  srcPath));
   tS.verifyTrue(strcmp(fileS.tgPath,   tgPath));

   idx = idx + 1;
   srcPath = fullfile(srcDefaultDir, 'test3.tex');
   tgPath  = fullfile(tgDefaultDir,  'test3.tex');
   pS.add('test3.tex');
   fileS = pS.fileListV{idx};
   tS.verifyTrue(strcmp(fileS.srcPath,  srcPath));
   tS.verifyTrue(strcmp(fileS.tgPath,   tgPath));


   % Sub dir
   idx = idx + 1;
   srcPath = 'subdir/test4.txt';
   pS.add(srcPath);
   fileS = pS.fileListV{idx};
   tS.verifyTrue(strcmp(fileS.srcPath,  fullfile(srcDefaultDir, srcPath)));
   tS.verifyTrue(strcmp(fileS.tgPath,   fullfile(tgDefaultDir,  srcPath)));
end