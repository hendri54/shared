function subplot_axes_same(fhV, axisV)
% Set all subplot axes the same
%{
Set the max axis range of all figures
axisV overrides that

IN
   fhV
      vector of axis handles
   axisV (optional)
      desired axis ranges
%}

%% Input check
if ~isempty(axisV)
   if length(axisV) ~= 4
      error('Invalid axisV');
   end
end

if ~isa(fhV(1), 'matlab.graphics.axis.Axes')  &&  ~isa(fhV(1), 'double')
   error('Invalid');
end


%% Main

% Get max limits
[xLimV, yLimV] = figuresLH.common_axis_limits(fhV, axisV);

% % Override with target values
% if ~isempty(axisV)
%    if ~isnan(axisV(1))
%       xLimV(1) = axisV(1);
%    end
%    if ~isnan(axisV(2))
%       xLimV(2) = axisV(2);
%    end
%    if ~isnan(axisV(3))
%       yLimV(1) = axisV(3);
%    end
%    if ~isnan(axisV(4))
%       yLimV(2) = axisV(4);
%    end
% end

xlim(fhV(1), xLimV);
ylim(fhV(1), yLimV);

% % Override
% if ~isempty(axisV)
%    % Compute new x limits
%    xLimV = set_new_limits(axisV(1:2), get(fhV(1), 'xLim'));
%    if ~isempty(xLimV)
%       for i1 = 1 : length(fhV)
%          xlim(fhV(i1), xLimV);
%       end
%    end
%    
%    % Compute new y limits
%    yLimV = set_new_limits(axisV(3:4), get(fhV(1), 'yLim'));
%    if ~isempty(yLimV)
%       for i1 = 1 : length(fhV)
%          ylim(fhV(i1), yLimV);
%       end
%    end
% end


linkaxes(fhV);



end


% %% Set new axis limits
% function outV = set_new_limits(tgV, currentV)
%    idxV = find(~isnan(tgV));
%    if isempty(idxV)
%       outV = [];
%    else
%       outV = currentV;
%       outV(idxV) = tgV(idxV);
%    end
% end