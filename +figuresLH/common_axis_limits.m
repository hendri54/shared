function [xLimV, yLimV] = common_axis_limits(fhV, axisV)
% Given a set of figure (or subplot axis) handles, find the axis range that encompasses all
%{
IN:
   fhV
      figure or axis handles
   axisV
      fixed axis values (optional)
      can contain NaN to be ignored
%}

%% Input check

n = length(fhV);

if ~isempty(axisV)
   assert(length(axisV) == 4);
end


%% Get axis handles

if isa(fhV(1), 'matlab.ui.Figure')
   % Figure handles
   ahV = gobjects(1, n);
   for i1 = 1 : n
      ahV(i1) = get(fhV(i1), 'CurrentAxes');
   end   
   
elseif isa(fhV(1), 'double')  ||  isa(fhV(1), 'matlab.graphics.axis.Axes')
   % Axis handles
   ahV = fhV;
   
else
   error('Invalid');
end


%% Get limits

xLimV = zeros(1, 2);
yLimV = zeros(1, 2);

for i1 = 1 :n
   xLimNewV = get(ahV(i1), 'xLim');
   yLimNewV = get(ahV(i1), 'yLim');
   
   if i1 > 1
      % Keep the max
      xLimV(1) = min(xLimV(1), xLimNewV(1));
      xLimV(2) = max(xLimV(2), xLimNewV(2));
      yLimV(1) = min(yLimV(1), yLimNewV(1));
      yLimV(2) = max(yLimV(2), yLimNewV(2));
   else
      xLimV = xLimNewV;
      yLimV = yLimNewV;
   end
end


%% Override limits

% Override with target values
if ~isempty(axisV)
   if ~isnan(axisV(1))
      xLimV(1) = axisV(1);
   end
   if ~isnan(axisV(2))
      xLimV(2) = axisV(2);
   end
   if ~isnan(axisV(3))
      yLimV(1) = axisV(3);
   end
   if ~isnan(axisV(4))
      yLimV(2) = axisV(4);
   end
end


validateattributes(xLimV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'size', [1,2]})
validateattributes(yLimV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'size', [1,2]})

end