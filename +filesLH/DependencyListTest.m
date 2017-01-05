function DependencyListTest

lhS = const_lh;

% Initialize with directory
inPath = lhS.dirS.sharedDirV{1};
dl = filesLH.DependencyList(inPath);


% Initialize with file list
inListV = string({which('classify_lh'), which('cl_bounds_lh')});
dl = filesLH.DependencyList(inListV);
listV = dl.dependencies;


% Back up to zip file
zipFile = fullfile(lhS.dirS.testFileDir,  'DependencyListTest.zip');
dl.back_up_zip(zipFile,  true);

end