function common_base_directory_test

lhS = const_lh;
fileListV = {which('classify_lh.m'),  which('EnumLH.m'),  which('statsLH.std_w')};
baseDir = filesLH.common_base_directory(fileListV);
assert(strcmp(baseDir, lhS.dirS.sharedBaseDir));

end