function ProjectListLHtest

disp('Testing ProjectListLH');

compS = configLH.Computer([]);
fileNameStr = fullfile(compS.testFileDir, 'ProjectListLHtest');

plS = ProjectListLH(fileNameStr);

% Add a few projects
np = 5;
projV = cell(np, 1);
for i1 = 1 : np
   nameStr = sprintf('project%i', i1);
   baseDirV = {sprintf('baseLocal%i', i1),  sprintf('baseRemote%i', i1)};
   progDirV = {sprintf('progLocal%i', i1),  sprintf('progRemote%i', i1)};
   sharedDirM = [];
   suffixStr = sprintf('pr%i', i1);
   initFileName = sprintf('init%i', i1);
   pS = ProjectLH(nameStr, baseDirV{1}, progDirV{1}, sharedDirM, suffixStr, initFileName);
   plS.append({pS});
   projV{i1} = pS;
end

assert(plS.n == np);


% Save
plS.save;


% Load
pl2S = ProjectListLH(fileNameStr);


% Retrieve
for i1 = 1 : np
   pS = pl2S.retrieve(projV{i1}.nameStr);
   assert(strcmp(pS.suffixStr, projV{i1}.suffixStr));
end

end