function lHandle = plot45
% Add a 45 degree line to the current plot
% Return handle to the line
% ----------------------------------------

axisV = axis;
dx = axisV(2) - axisV(1);
x45V = [axisV(1) + 0.02 * dx,  axisV(2) - 0.02 * dx];
lHandle = line(x45V, x45V, 'LineStyle', '-', 'Color', 'k');

end
