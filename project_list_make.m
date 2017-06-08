function project_list_make
% Make list of projects for automated startup
%{
All dirs must be fully qualified (not ~ for home dir)
Assumes that remote dirs have same structure as local dirs, except root folder
Directories are sometimes case sensitive

Newer: in project_start
%}

lhS = const_lh;
% No longer needed
kureDir = lhS.dirS.baseDir;

% Define a few handy dirs
dropBoxDir = '/Users/lutz/Dropbox';
docuDir = fullfile(lhS.dirS.userDir, 'Documents');
dataDir = fullfile(docuDir, 'econ', 'data');

% Use default project file
plS = ProjectListLH;


% % Dummy project that just goes to shared dir
% baseDirV = {lhS.dirS.sharedDirV{3}, kureDir};
% progDirV = baseDirV;
% pS = ProjectLH('Shared code', baseDirV, progDirV, [], 'shared', []);
% plS.append(pS);



% Census data (Borrowing constraints)
baseDirV = {fullfile(dropBoxDir, 'hc', 'borrow_constraints', 'census'), kureDir};
progDirV = {fullfile(baseDirV{1}, 'prog'), kureDir};
pS = ProjectLH('Borowing constraints CENSUS', baseDirV{1}, progDirV{1}, [], 'bcc', []);
plS.append(pS);



% CP: Decompose growth in college premium, fixed age profiles
baseDirV = {fullfile(dropBoxDir, 'hc', 'school_ojt', 'collprem', 'model1'), ...
   fullfile(kureDir, 'hc', 'school_ojt', 'collprem', 'model1')};
progDirV = {fullfile(baseDirV{1}, 'prog'), ...
   fullfile(baseDirV{2}, 'prog')};
pS = ProjectLH('Collprem', baseDirV{1}, progDirV{1}, [], 'cp', []);
plS.append(pS);


% Jones: bounding role of H for income gaps
baseDirV = {fullfile(dropBoxDir, 'cross_country', 'jones'),  kureDir};
progDirV = {fullfile(baseDirV{1}, 'progs'),  kureDir};
pS = ProjectLH('Jones generalize approach', baseDirV{1}, progDirV{1}, [], 'jones', []);
plS.append(pS);


% Manuelli / Seshadri (2014 AER)
baseDirV = {fullfile(dropBoxDir, 'hc', 'ms2014'), kureDir};
progDirV = {fullfile(baseDirV{1}, 'prog'), kureDir};
pS = ProjectLH('MS2014', baseDirV{1}, progDirV{1}, [], 'ms', []);
plS.append(pS);

% Manuelli / Seshadri (2014 AER). Heterogeneous agents
baseDirV = {fullfile(dropBoxDir, 'hc', 'ms2014', 'model2'), kureDir};
progDirV = {fullfile(baseDirV{1}, 'prog'), kureDir};
pS = ProjectLH('MS2014 hetero', baseDirV{1}, progDirV{1}, [], 'msh', []);
plS.append(pS);


% Occupational wages in low income countries
baseDirV = {fullfile(dropBoxDir, 'hc', 'ipums_migrants', 'occupation wages'), kureDir};
progDirV = {fullfile(baseDirV{1}, 'prog'), kureDir};
pS = ProjectLH('Occupational wages', baseDirV{1}, progDirV{1}, [], 'ow', []);
plS.append(pS);


% School-OJT: accounting for experience profiles
baseDir = fullfile(dropBoxDir, 'hc', 'school_ojt', 'experience', 'model2');
baseDirV = {baseDir,  fullfile(kureDir, 'school_ojt', 'experience', 'model2')};
progDirV = {fullfile(baseDir, 'prog'), ...
   fullfile(kureDir, 'school_ojt', 'experience', 'model2', 'prog')};
pS = ProjectLH('BP experience profiles', baseDirV{1}, progDirV{1}, [], 'so1', []);
plS.append(pS);


%% Ben-Porath

% Replicate HVY 2011
baseDir = fullfile(dropBoxDir, 'hc', 'hvy2011');
progDir = fullfile(baseDir, 'prog');
pS = ProjectLH('HVY 2011', baseDir, progDir, [], 'hvy', []);
plS.append(pS);


%% Immigration

% Document immigrant earnings in low income countries
baseDirV = {fullfile(lhS.dirS.baseDir, 'econ', 'migration', 'ipumsi'), kureDir};
progDirV = {fullfile(baseDirV{1}, 'prog'),  kureDir};
pS = ProjectLH('IPUMS migrants', baseDirV{1}, progDirV{1}, [], 'imig', []);
plS.append(pS);



%% Todd

% % Ipums migrants (version with Todd)
% baseDirV = {fullfile(dropBoxDir, 'hc', 'ipums_migrants'),  kureDir};
% progDirV = {fullfile(baseDirV{1}, 'prog'),  kureDir};
% pS = ProjectLH('IPUMS migrants', baseDirV{1}, progDirV{1}, [], 'imig', []);
% plS.append(pS);


% CPS wage profiles
baseDirV = {fullfile(dropBoxDir, 'hc', 'ipums_migrants', 'cps'),  kureDir};
progDirV = {fullfile(baseDirV{1}, 'prog'),  kureDir};
pS = ProjectLH('IPUMS migrants cps', baseDirV{1}, progDirV{1}, [], 'icps', []);
plS.append(pS);



%% Oksana

baseDir = fullfile(dropBoxDir, 'hc', 'college_risk');
progDir = fullfile(baseDir, 'model1', 'prog');
pS = ProjectLH('College risk', baseDir, progDir, [], 'cr', []);
plS.append(pS);

% Risky school and gradpred (same model)
baseDir = fullfile(dropBoxDir, 'risky_school', 'gradpred');      % ,  fullfile(kureDir, 'gradpred')};
progDir = fullfile(baseDir, 'model1', 'prog');
   % fullfile(baseDirV{1}, 'model1', 'prog'),  fullfile(baseDirV{2}, 'model1', 'prog')};

% % First entry is for LH progs
% sharedDirV = {'prog', 'prog_rs', 'export_fig'};
% sharedDirM = cell(length(sharedDirV) + 1, 2);
% for i1 = 1 : length(sharedDirV)
%    for iComp = 1 : 2
%       sharedDirM{i1, iComp} = fullfile(baseDirV{iComp}, 'shared', sharedDirV{i1});
%    end
% end
% % Add the "shared" shared dir
% sharedDirM(length(sharedDirV) + 1,:) = {lhS.localS.sharedDirV{3}, lhS.kureS.sharedDirV{3}};

% Shared rs programs (shared with data routines)
sharedDirV = {fullfile(baseDir, 'shared', 'prog_rs')};

pS = ProjectLH('Risky college', baseDir, progDir, sharedDirV, 'rs5', []);
plS.append(pS);


%% Classes

% Econ821
baseDir = fullfile(dropBoxDir, 'classes', 'econ821');
progDir = fullfile(baseDir, 'progs');
baseDirV = {baseDir, baseDir};
progDirV = {progDir, progDir};
pS = ProjectLH('Econ821', baseDirV{1}, progDirV{1}, [], '821', []);
plS.append(pS);



%% Class grades

baseDirV = {fullfile(dropBoxDir, 'classes', 'econ520'),  []};
progDirV = {fullfile(baseDirV{1}, 'grades520'), []};
pS = ProjectLH('Grades 520', baseDirV{1}, progDirV{1}, [], 'grades520', []);
plS.append(pS);

baseDirV = {fullfile(dropBoxDir, 'classes', 'econ720'),  []};
progDirV = {fullfile(baseDirV{1}, 'grades720'), []};
pS = ProjectLH('Grades 720', baseDirV{1}, progDirV{1}, [], 'grades720', []);
plS.append(pS);

% baseDirV = {'/Users/lutz/Documents/data/web/hendri54.github.io/econ520', []};
% progDirV = baseDirV;
% pS = ProjectLH('Econ 520', baseDirV{1}, progDirV{1}, [], '520', []);
% plS.append(pS);

% baseDirV = {'/Users/lutz/Documents/data/web/hendri54.github.io/econ720', []};
% progDirV = baseDirV;
% pS = ProjectLH('Schedule 720', baseDirV{1}, progDirV{1}, [], '720', []);
% plS.append(pS);

baseDirV = {'/Users/lutz/Documents/data/web/hendri54.github.io/econ920', []};
progDirV = baseDirV;
pS = ProjectLH('Econ 920', baseDirV{1}, progDirV{1}, [], '920', []);
plS.append(pS);


%% Data projects

% Barro Lee 2013
baseDirV = {fullfile(dataDir, 'BarroLee', 'bl2013'), kureDir};
progDirV = {fullfile(baseDirV{1}, 'prog'), kureDir};
pS = ProjectLH('Barro Lee 2013', baseDirV{1}, progDirV{1}, [], 'bl2013', []);
plS.append(pS);


% Census (PUMS)
baseDirV = {fullfile(docuDir, 'econ', 'data', 'MicAnalyst'), kureDir};
progDirV = {fullfile(baseDirV{1}, 'prog'), kureDir};
pS = ProjectLH('Census data', baseDirV{1}, progDirV{1}, [], 'pums', []);
plS.append(pS);

% Census year 2000 (PUMS)
%  requires PUMS
baseDirV = {fullfile(docuDir, 'econ', 'data', 'MicAnalyst', 'pums2000_5pct'), kureDir};
progDirV = {fullfile(baseDirV{1}, 'progs'), kureDir};
pS = ProjectLH('Census data 2000', baseDirV{1}, progDirV{1}, [], 'p2000', []);
plS.append(pS);


% % CPS
% baseDirV = {fullfile(docuDir, 'econ', 'data', 'cps'), kureDir};
% progDirV = {fullfile(baseDirV{1}, 'prog'), kureDir};
% pS = ProjectLH('CPS data', baseDirV{1}, progDirV{1}, [], 'cps', []);
% plS.append(pS);

% CPS earnings profiles
baseDirV = {'/Users/lutz/Documents/econ/data/Cps/earn_profiles/', kureDir};
progDirV = {fullfile(baseDirV{1}, 'progs'),  kureDir};
pS = ProjectLH('CPS earnings profiles', baseDirV{1}, progDirV{1}, [], 'cpsearn', []);
plS.append(pS);


% HERI freshman surveys (CIRP)
baseDirV = {'/Users/lutz/Documents/econ/data/HERI/tfs', kureDir};
progDirV = {fullfile(baseDirV{1}, 'progs'),  kureDir};
pS = ProjectLH('HERI freshman surveys', baseDirV{1}, progDirV{1}, [], 'tfs', []);
plS.append(pS);


% IpumsI
baseDirV = {'/Users/lutz/Documents/econ/data/ipumsi', kureDir};
progDirV = {fullfile(baseDirV{1}, 'prog'), kureDir};
pS = ProjectLH('IPUMSI', baseDirV{1}, progDirV{1}, [], 'ipumsi', []);
plS.append(pS);


% NLSY79
baseDirV = {fullfile(docuDir, 'econ', 'data', 'nlsy79a'), kureDir};
progDirV = {fullfile(baseDirV{1}, 'prog'), kureDir};
pS = ProjectLH('NLSY79', baseDirV{1}, progDirV{1}, [], 'nlsy', []);
plS.append(pS);


% PWT
baseDirV = {fullfile(docuDir, 'econ', 'data', 'pwt', 'pwt8'), kureDir};
progDirV = {fullfile(baseDirV{1}, 'progs'), kureDir};
pS = ProjectLH('PWT8', baseDirV{1}, progDirV{1}, [], 'pwt8', []);
plS.append(pS);

% WDI
baseDirV = {fullfile(lhS.dirS.baseDir, 'econ', 'data', 'worldbank', 'wdi2013'), kureDir};
progDirV = {fullfile(baseDirV{1}, 'prog'), kureDir};
pS = ProjectLH('WDI 2013', baseDirV{1}, progDirV{1}, [], 'wdi2013', []);
plS.append(pS);


%% Optimization

baseDir = fullfile(lhS.dirS.sharedBaseDir, 'imfil');
progDir = baseDir;
pS = ProjectLH('imfil', baseDir, progDir, [], 'imfil', []);
plS.append(pS);

% NLOPT requires additional startup using optim_lh.nloptinit
baseDir = fullfile(lhS.dirS.sharedBaseDir, 'nlopt', 'nlopt-2.4.2', 'octave');
progDir = baseDir;
pS = ProjectLH('nlopt', baseDir, progDir, [], 'nlopt', []);
plS.append(pS);


% Save
plS.save;



end