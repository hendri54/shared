function [fid, fPath] = open_test_file(fileName)
% Open file for writing in test file directory

compS = configLH.Computer([]);

fPath = fullfile(compS.testFileDir, fileName);
fid = fopen(fPath, 'w');

end