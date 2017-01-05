function axis_range(axisV)
% Set axis range for a plot
% To keep something at default: set to NaN

axis0V = axis;
idxV = find(~isnan(axisV));
axis0V(idxV) = axisV(idxV);
axis(axis0V);


end