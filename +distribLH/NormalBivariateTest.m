function NormalBivariateTest

disp('Testing NormalBivariate');

dbg = 111;
rng(432);

% Parameters of the bivariate normal
meanV = randn(2, 1);
stdV = 0.5 * rand(2,1);
corr = 0.65;

% Construct object
nbS = distribLH.NormalBivariate(meanV, stdV, corr);

% Retrieve covariance matrix
validateattributes(nbS.covM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive', 'size', [2,2]})


% Draw random numbers
n = 1e5;
xM = mvnrnd(meanV, nbS.covM, n);

% Check that correlation coefficient comes out right
corrM = corrcoef(xM);
checkLH.approx_equal(corrM(1,2), corr, 1e-2, []);


%% Conditional expectation

% analytical: E(x1 | x2)
e1V = nbS.cond_expect(xM(:,2), dbg);

% To test: regress x1 net of conditional mean against x2V and check for 0 coefficients
mdl = fitlm(xM(:,2),  xM(:,1) - e1V, 'linear');
checkLH.approx_equal(mdl.Coefficients.Estimate(:),  [0; 0],  1e-2, []);


%% Conditional density x1 | x2
% Test: by testing conditional expectation / var

x1V = linspace(-4, 4, 1e3);

% Test for these values of x2
x2V = linspace(-2, 2, 50)';
for i1 = 1 : length(x2V)
   % Conditional density at x1 grid | x2
   outV = nbS.cond_density(x1V, x2V(i1) * ones(size(x1V)), dbg);
   % Implied moments
   [xStd, xMean] = stats_lh.std_w(x1V, outV, dbg);
   
   % Compare with analytical results
   e1 = nbS.cond_expect(x2V(i1), dbg);
   checkLH.approx_equal(e1, xMean, 1e-2, []);
   checkLH.approx_equal(nbS.cond_var ^ 0.5,  xStd, 1e-2, []);
end


% %% Conditional density of x1 given x2 in interval
%     only works for standard normal; but could possibly be extended
% 
% % For wide interval: must be same as unconditional density
% x1V = linspace(-2, 2, 100);
% densV = cond_density_interval(nbS, x1V, -6, 6, dbg);
% dens2V = normpdf(x1V, nbS.meanV(1),  nbS.stdV(1) ^ 2);
% if max(abs(dens2V - densV)) > 1e-3
%    keyboard;
% end
% fprintf('Dev for conditional density: %.3f \n',  max(abs(dens2V - densV)));
% checkLH.approx_equal(densV, dens2V, 1e-3, []);
% 
% 
% % ****** Test: check that integral of density = mass in interval (simulated)
% 
% % 100 intervals to use for testing
% x2LbV = randn(100, 1);
% x2UbV = x2LbV + rand(100, 1);
% 
% % Loop over intervals
% for i1 = 1 : length(x2LbV)
%    % x1 on a grid with partial coverage
%    x1Low = -4 + 6 * rand(1,1);
%    x1High = x1Low + 2 * rand(1,1);
%    
%    x1BoundV = linspace(x1Low, x1High, 1e3);
%    x1V = 0.5 .* (x1BoundV(1:(end-1)) + x1BoundV(2 : end));
%    % Width over intervals
%    x1WidthV = diff(x1BoundV);
% 
%    % Density of x1 | x2 in interval
%    densV = cond_density_interval(nbS, x1V, x2LbV(i1), x2UbV(i1), dbg);
%    % Crude approximation for mass in interval
%    intMass = sum(densV .* x1WidthV);
%    
%    % Simulated
%    idxV  = find(xM(:,2) >= x2LbV(i1)  &  xM(:,2) <= x2UbV(i1)  &  xM(:,1) >= x1Low  &  xM(:,1) <= x1High);
%    idx2V = find(xM(:,2) >= x2LbV(i1)  &  xM(:,2) <= x2UbV(i1));
%    simMass = length(idxV) ./ length(idx2V);
%    %checkLH.approx_equal(simMass, intMass, 1e-2, []);
%    if abs(simMass - intMass) > 1e-2
%       fprintf('%3i:  sim: %.2f   analytical: %.2f \n',  i1, simMass, intMass);
%    end
% end
% 


%% Conditional expectation of x1 given x2 in interval

% For wide interval: should be unconditional expectation of x1
e1 = nbS.cond_expect_interval(-6, 6, dbg);
checkLH.approx_equal(e1,  nbS.meanV(1), 1e-2, []);

% For tiny interval: should be E(x1 | x2)
x2V = linspace(meanV(2) - 2 * stdV(2),  meanV(2) + 1.5 * stdV(2), 50);
e1V = nbS.cond_expect_interval(x2V, x2V + 0.05, dbg);
e2V = nbS.cond_expect(x2V + 0.025, dbg);
checkLH.approx_equal(e1V,  e2V, 1e-2, []);


% ***** Test: for many x2 intervals, compute simulated mean and analytical mean

% Set up intervals
n2 = 1e3;
x2LbV = linspace(nbS.meanV(2) - 3 * nbS.stdV(2), nbS.meanV(2) + 3 * nbS.stdV(2), n2)';
x2UbV = x2LbV + min(0.1, rand(n2, 1));
e1V = cond_expect_interval(nbS, x2LbV, x2UbV, dbg);

% Simulated mean in each interval
mean1V = nan(size(e1V));
for i1 = 1 : length(mean1V)
   idxV = find(xM(:,2) >= x2LbV(i1)  &  xM(:,2) <= x2UbV(i1));
   if length(idxV) > 5
      mean1V(i1) = mean(xM(idxV,1));
   end
   
   % Make sure answer is inside E(x1 | interval bounds)
   if ~isnan(e1V(i1))
      eEndPointV = nbS.cond_expect([x2LbV(i1), x2UbV(i1)], dbg);
      assert(e1V(i1) >= min(eEndPointV));
      assert(e1V(i1) <= max(eEndPointV));
   end
end

% Regress sample means on analytical means
mdl = fitlm(e1V, mean1V - e1V,  'linear');
checkLH.approx_equal(mdl.Coefficients.Estimate(:),  [0;0], 5e-2, []);


end