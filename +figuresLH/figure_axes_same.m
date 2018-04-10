function figure_axes_same(fhV, axisV)
% Set all figure axes the same
%{
Set the max axis range of all figures
axisV overrides that

IN
   fhV
      vector of figure handles (for separate figures)
   axisV (optional)
      desired axis ranges
%}

%% Input check
if ~isempty(axisV)
   if length(axisV) ~= 4
      error('Invalid axisV');
   end
end

% Must be figure or axis handle
if ~isa(fhV(1), 'matlab.ui.Figure')  && ~isa(fhV(1), 'matlab.graphics.axis.Axes')
   fhV
   error('Invalid');
end


%% Find max axis dimensions of all figures

[xLimV, yLimV] = figuresLH.common_axis_limits(fhV, axisV);
axisValV = [xLimV, yLimV];
validateattributes(axisValV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'size', [1,4]})


%% Set axes

% if ~isempty(axisV)
%    idxV = find(~isnan(axisV));
%    if ~isempty(idxV)
%       axisValV(idxV) = axisV(idxV);
%    end
% end

for i1 = 1 : length(fhV)
   %figure(fhV(i1));
   %axis(gca, axisValV);
   if isa(fhV(i1), 'matlab.ui.Figure')
      ah = get(fhV(i1), 'CurrentAxes');
   else
      ah = fhV(i1);
   end
   xlim(ah, axisValV(1:2));
   ylim(ah, axisValV(3:4));
end


end