function [dev, betaV, seV] = regression_test(trueM, simM, wtM, doShow)
% Test by regression that simulated data are consistent with "true" outcomes
%{
Regress simulated on true
Check for 0 intercept, 1 slope

IN
   trueM
      true outcome by state
   simM
      simulated outcome by state
   wtM
      weights (e.g. to downweight rare states or states that cannot be solved precisely)
      scalar weights are expanded. Provide wtM = []
   doShow
      show scatter plot?

OUT
   dev = max(abs(beta - [0;1]) / se(beta))
      how many std deviations are regression coefficient from 45 degree line?
   betaV
      regression coefficients; should be [0;1]
   seV
      std errors

Change:
   If data are very far from 0, then intercept can be quite a bit off.
   Better to look at pct deviation between regression and 45 degree line over range where we
   actually observe something

   Better: test hypothesis of 0 intercept and unit slope. Return prob of reject
%}

%% Input check

if ~isequal(size(trueM), size(simM))
   disp(size(trueM));
   disp(size(simM));
   error('Sizes do not match');
end
assert(isa(doShow, 'logical'));


%% Main

if ~isempty(wtM)
   idxV = find(~isnan(trueM(:)) & ~isnan(simM(:))  &  wtM(:) > 0);
   assert(length(idxV) > 4);
   mdl = fitlm(trueM(idxV), simM(idxV), 'linear', 'Weights', wtM(idxV));
else
   idxV = find(~isnan(trueM(:)) & ~isnan(simM(:)));
   assert(length(idxV) > 4,  'Not enough valid observations');
   mdl = fitlm(trueM(idxV), simM(idxV), 'linear');
end

betaV = mdl.Coefficients.Estimate;
seV = mdl.Coefficients.SE;
dev = max(abs(betaV - [0;1]) ./ max(0.02, seV));
fprintf('regression_test dev = %.3f \n', dev);


%% Show
if doShow
   fprintf('  beta: ');
   for i1 = 1 : length(betaV)
      fprintf('  %.3f (%.3f)',  betaV(i1), seV(i1));
   end
   fprintf('\n');
   
   xMin = min(trueM(:));
   xMax = max(trueM(:));
   yPredV = mdl.feval([xMin; xMax]);

   fh = figure('visible', 'on');
   hold on;
   plot(trueM(:), simM(:), '.');
   plot([xMin, xMax], [xMin,xMax], '--');
   plot([xMin, xMax], yPredV, '-');
   xlabel('True');
   ylabel('Sim');
   legend({'Data', '45 degree', 'OLS'}, 'location', 'southeast');
   pause;
   close;
end


end