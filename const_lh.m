function cS = const_lh
% Constants to be shared across projects
% Directories are defined in global lhS

cS.missVal = -9191;

% Sex codes
cS.male = 1;
cS.female = 2; 
cS.both = 3;
cS.sexStrV = {'men', 'women', 'both'};

cS.raceWhite = 93;

% When we have model and data, index in this order
cS.iModel = 1;
cS.iData = 2;


%% Demographics

% How old is a person in year of birth?
cS.demogS.ageInBirthYear = 1;


%% Directories
% Location of shared dirs depends on whether we are running local or not

fs = filesep;
userDir = fullfile(fs, 'Users', 'lutz');
docuDir = fullfile(userDir, 'Documents');


% ****  Local
% Also tail end of directories when remote

cS.dirS = add_derived_dirs(userDir, docuDir);

if exist(userDir, 'dir')
   cS.runLocal = true;
   %cS.dirS = cS.localS;
else
   cS.runLocal = false;
   %cS.dirS = cS.kureS;
end

% File with startup info for projects
cS.projectFile = fullfile(cS.dirS.iniFileDir, 'project_list');


% ****  Remote
% Info for modifying directories in cS.dirS

% This is the only place where info about the linux cluster should appear
cS.clusterName = 'longleaf';

switch cS.clusterName
   case 'longleaf'
      cS.mountedVolume = '/Volumes/longleaf/';
      % Users/lutz hangs off that
      cS.remoteBaseDir = '/nas/longleaf/home/lhendri/';
      %userDir = fullfile(cS.remoteBaseDir, 'Users', 'lutz');
      %cS.kureS = add_derived_dirs(userDir, fullfile(userDir, 'Documents'));
   case 'killdevil'
      cS.mountedVolume = '/Volumes/killdevil/';
      cS.remoteBaseDir = '/nas02/home/l/h/lhendri/';
      %userDir = fullfile(cS.remoteBaseDir, 'Users', 'lutz');
      %cS.kureS = add_derived_dirs(userDir, fullfile(userDir, 'Documents'));
   otherwise
      error('Invalid');
end




end


%% Local: add derived dirs
%{ 
Given a user dir (e.g. /users/lutz/) and a base dir (e.g. /users/lutz/documents)
hang all other dirs off those
Assumes that remote dir structure is the same as local
%}
function dirS = add_derived_dirs(userDir, baseDir)

dirS.userDir = userDir;
dirS.baseDir = baseDir;

% All general purpose matlab code hangs off this dir
dirS.sharedBaseDir = fullfile(dirS.baseDir, 'econ', 'Matlab');
% Startup files
dirS.iniFileDir = fullfile(dirS.sharedBaseDir, 'ini_files');
% For github repos from other users
dirS.repoDir = fullfile(dirS.sharedBaseDir, 'github');

% Shared progs
lhDir = fullfile(dirS.sharedBaseDir, 'LH');
dirS.sharedDirV = {lhDir, fullfile(dirS.repoDir, 'export_fig'), fullfile(dirS.sharedBaseDir, 'shared')};

% Test files go here
dirS.testFileDir  = fullfile(lhDir, 'test_files');
dirS.testFileDir2 = fullfile(lhDir, 'test_files2');

% Temporary files go here
dirS.tempDir = fullfile(dirS.sharedBaseDir, 'temp');

end