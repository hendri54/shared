function zip_files_test

lhS = const_lh;
zipFile = fullfile(lhS.dirS.testFileDir,  'zip_files_test.zip');
fileListV = {which('classify_lh.m'),  which('EnumLH.m'),  which('statsLH.std_w')};

% Need inspect file by hand to verify contents (not ideal)
filesLH.zip_files(zipFile, fileListV, true);
filesLH.zip_files(zipFile, fileListV, false);

end