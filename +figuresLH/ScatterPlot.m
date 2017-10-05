% Scatter plot with option to print smoothed line
%{
Weighted data can be shown as marker sizes
%}
classdef ScatterPlot < handle
      
properties
   figS  FigureLH
   % Smoothing method
   %  'none': don't show smoothed line
   smoothingMethod  char = 'rloess';
   smoothingParam   double = 0.2;
   
   % Ignore NaN when plotting?
   ignoreNan  logical = true
end

properties (Dependent)
   % Show smoothed line?
   useSmoothing
end

methods
   %% Constructor
   %{
   Can pass a properties of a FigureLH object. Can also pass the FigureLH object directly
   %}
   function spS = ScatterPlot(figS, varargin)
      if isempty(figS)
         if (nargin < 2)  ||  isempty(varargin)
            spS.figS = FigureLH;
         else
            spS.figS = FigureLH(varargin{:});
         end
      else
         spS.figS = figS;
      end
   end
   
   
   %% Dependent
   function out1 = get.useSmoothing(spS)
      out1 = ~strcmpi(spS.smoothingMethod, 'none');
   end
   
   
   %% Close figure
   function close(spS)
      spS.figS.close;
   end
   
   
   %% Format
   function format(spS)
      spS.figS.format;
   end
   
   
   %% Save
   function save(spS, figFn, saveFigures)
      spS.figS.save(figFn, saveFigures);
   end
   
   
   %% Produce smooth line through scatter
   function [xOutV, yOutV] = smooth_line(spS, xV, yV)
      validateattributes(xV, {'numeric'}, {'nonempty', 'real'})
      validateattributes(yV, {'numeric'}, {'nonempty', 'real'})
      
      xV = xV(:);
      yV = yV(:);
      if spS.ignoreNan
         idxV = find(~isnan(xV(:))  &  ~isnan(yV(:)));
         assert(length(idxV) > 2,  'Too few data points');
         sortM = sortrows([xV(idxV), yV(idxV)]);
      else
         assert(~any(isnan(xV(:))),  'NaN x values encountered');
         assert(~any(isnan(yV(:))),  'NaN y values encountered');
         sortM = sortrows([xV(:), yV(:)]);
      end
      yOutV = smooth(sortM(:,1), sortM(:,2), spS.smoothingParam, spS.smoothingMethod);
      xOutV = sortM(:,1);
   end
   
   
   %% Add regression line and display it
   function add_regression_line(spS, xV, yV, wtV)
      [lineHandle, outStr] = figuresLH.regression_line(xV, yV, wtV);
      set(lineHandle, 'Color', 'k');
      
      % show the string (positioning is crude)
      axisV = axis;
      x1 = axisV(1) + 0.1 * (axisV(2) - axisV(1));
      y1 = axisV(3) + 0.1 * (axisV(4) - axisV(3));
      text(x1, y1, outStr);
   end
   
   
   %% Scatter and smooth line
   %{
   Leaves plot open
   
   IN
      wtV  ::  double
         weights; optional
   %}
   function plot(spS, xV, yV, wtV)
      validateattributes(xV, {'numeric'}, {'nonempty', 'real'})
      validateattributes(yV, {'numeric'}, {'nonempty', 'real'})

      if nargin < 4
         weighted = false;
      else
         weighted = true;
         validateattributes(wtV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', '>=', 0, 'size', size(xV)})
      end
      
      % *******  Plot
      spS.figS.new;
      hold on;
      iLine = 0;
      
      iLine = iLine + 1;
      if weighted
         % Marker size: proportional to sqrt of weight, but must be visible
         medianWt = median(wtV);
         mkSizeV = max(30, min(1e3, (wtV ./ medianWt) .* 80));
         % Does not set correct marker color +++
         scatter(gca, xV, yV, mkSizeV);
      else
         % scatter(gca, xV, yV);
         spS.figS.plot_scatter(xV, yV, iLine);
      end
      
      if spS.useSmoothing
         iLine = iLine + 1;
         [xSmoothV, ySmoothV] = spS.smooth_line(xV, yV);
         spS.figS.plot_line(xSmoothV, ySmoothV, iLine);
      end
      
      % 45 degree line
      hold off;
   end
end
   
end
