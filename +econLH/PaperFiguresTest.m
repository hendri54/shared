function PaperFiguresTest

disp('Testing PaperFigures');

lhS = const_lh;
srcDefaultDir = lhS.testFileDir;
tgDefaultDir  = lhS.testFileDir2;
n = 25;

pS = econLH.PaperFigures(srcDefaultDir, tgDefaultDir, n);

idx = 1;
pS.add('abc.pdf', [], []);
fileS = pS.fileListV{idx};
assert(strcmp(fileS.srcPath,  fullfile(srcDefaultDir, 'abc.pdf')));
assert(strcmp(fileS.tgPath,   fullfile(tgDefaultDir,  'abc.pdf')));

idx = idx + 1;
srcPath = fullfile(srcDefaultDir, 'test1.tex');
pS.add('test1.tex', 'new1.tex', []);
fileS = pS.fileListV{idx};
assert(strcmp(fileS.srcPath,  srcPath));
assert(strcmp(fileS.tgPath,   fullfile(tgDefaultDir,  'new1.tex')));

idx = idx + 1;
srcPath = fullfile(lhS.baseDir, 'test2.tex');
tgPath  = fullfile(tgDefaultDir, 'test2', 'new2.tex');
pS.add(srcPath, 'new2.tex', 'test2');
fileS = pS.fileListV{idx};
assert(strcmp(fileS.srcPath,  srcPath));
assert(strcmp(fileS.tgPath,   tgPath));

idx = idx + 1;
srcPath = fullfile(srcDefaultDir, 'test3.tex');
tgPath  = fullfile(tgDefaultDir,  'test3.tex');
pS.add('test3.tex');
fileS = pS.fileListV{idx};
assert(strcmp(fileS.srcPath,  srcPath));
assert(strcmp(fileS.tgPath,   tgPath));



end