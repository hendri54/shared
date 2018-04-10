function tests = fullpaths_test

tests = functiontests(localfunctions);

end


function oneTest(testCase)

% compS = configLH.Computer([]);

% Local: no change to dirs
dirInV = '/Users/lutz';
dirOutV = filesLH.fullpaths(dirInV, true);
assert(strcmp(dirInV, dirOutV) > 0);

% Syntax for remote
remoteS = configLH.Computer('longleaf');
dirOutV = filesLH.fullpaths(dirInV, false);
dirModifiedV = fullfile(remoteS.baseDir, dirInV);
assert(strcmp(dirOutV,  dirModifiedV) > 0);

% Syntax with cell array
filesLH.fullpaths({dirInV, dirInV});

% Check that nothing changes when remote dir already has base dir
dirOutV = filesLH.fullpaths(dirModifiedV, false);
assert(strcmp(dirOutV,  dirModifiedV) > 0);


end