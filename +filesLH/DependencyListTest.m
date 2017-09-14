function DependencyListTest

compS = configLH.Computer([]);

% Initialize with directory
inPath = lhS.dirS.sharedDirV{1};
dl = filesLH.DependencyList(inPath);


% Initialize with file list
inListV = string({which('ces_lh'), which('devvectLH')});
dl = filesLH.DependencyList(inListV);
listV = dl.dependencies;


% Back up to zip file
zipFile = fullfile(compS.testFileDir,  'DependencyListTest.zip');
dl.back_up_zip(zipFile,  true);

end