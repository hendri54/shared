function std_w_test
% Test function

fprintf('\nTesting std_w\n');

dbg = 111;
rng(34);


%% Case with known mean and std

xM = randn([1e5, 3]);
wtInM = ones(size(xM));

[sdV, xMeanV] = statsLH.std_w(xM, wtInM, dbg);

meanDev = max(abs(xMeanV - 0));
sdDev = max(abs(sdV - 1));

% fprintf('Deviation for std normal rv: mean %f sd: %f \n', meanDev, sdDev);
if abs(meanDev) > 5e-3  ||  abs(sdDev > 5e-3)
   fprintf('meanDev: %.3f   sdDev: %.3f \n', meanDev, sdDev);
   error('Invalid');
end


end