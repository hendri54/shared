function tests = test_all

tests = functiontests(localfunctions);

end


function fullpathsTest(testCase)

lhS = const_lh;

% Local: no change to dirs
dirInV = '/Users/lutz';
dirOutV = filesLH.fullpaths(dirInV, true);
assert(strcmp(dirInV, dirOutV) > 0);

% Syntax for remote
dirOutV = filesLH.fullpaths(dirInV, false);
dirModifiedV = fullfile(lhS.remoteBaseDir, dirInV);
assert(strcmp(dirOutV,  dirModifiedV) > 0);

% Syntax with cell array
filesLH.fullpaths({dirInV, dirInV});

% Check that nothing changes when remote dir already has base dir
dirOutV = filesLH.fullpaths(dirModifiedV, false);
assert(strcmp(dirOutV,  dirModifiedV) > 0);


end