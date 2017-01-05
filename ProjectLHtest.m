function tests = ProjectLHtest

tests = functiontests(localfunctions);

end


function unitTest(testCase)

disp('Testing Project class');

lhS = const_lh;
nameStr = 'Test project';
suffixStr = 'test';
initFileName = 'init_test';

% baseDirV = {lhS.localS.sharedDirV{1},  lhS.kureS.sharedDirV{1}};
% progDirV = {lhS.localS.iniFileDir, lhS.kureS.baseDir};
% sharedDirM = cell(3, 2);
% for ir = 1 : 3
%    sharedDirM{ir,1} = lhS.localS.sharedDirV{ir};
%    sharedDirM{ir,2} = lhS.kureS.sharedDirV{ir};
% end

baseDir = lhS.dirS.sharedDirV{1};
progDir = lhS.dirS.iniFileDir;
sharedDirV = lhS.dirS.sharedDirV;

pS = ProjectLH(nameStr, baseDir, progDir, sharedDirV, suffixStr, initFileName);

% % Are we running local?
% [~, runLocal] = pS.run_local;
% assert(runLocal);

pS.add_path;

p2S = ProjectLH(nameStr, baseDir, progDir, [], suffixStr, []);


end