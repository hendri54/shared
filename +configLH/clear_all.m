function clear_all
% Clears all variables. Equivalent to restarting Matlab

compS = configLH.Computer([]);
cd(compS.sharedDirV{1});
clear compS;

clear classes;

startup;

end