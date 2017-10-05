function [lineHandle, outStr] = regression_line(xV, yV, wtV)
% Add a regression line to an open plot (gca)
%{
IN
   xV, yV  ::  double
      x and y values plotted
   wtV  ::  double  (optional)
      weights

OUT
   regrStr  ::  char
      string of the form \beta=0.92 (0.21)
%}

if nargin < 3
   wtV = [];
end

% Run regression
if isempty(wtV)
   mdl = fitlm(xV(:),  yV(:));
else
   mdl = fitlm(xV(:),  yV(:),  'Weights', wtV);
end

% Extract coefficients
bIdx = find(strcmpi('x1', mdl.CoefficientNames));
assert(length(bIdx) == 1);

b1 = mdl.Coefficients.Estimate(bIdx);
b1se = mdl.Coefficients.SE(bIdx);

% Formatted string
nf = formatLH.NumberFormat;
outStr = sprintf('\\beta=%s (%s)',  nf.format(b1), nf.format(b1se));

% Add regression line to plot
xHatV = [min(xV); max(xV)];
yHatV = predict(mdl, xHatV);
hold on;
lineHandle = line(xHatV, yHatV);


end