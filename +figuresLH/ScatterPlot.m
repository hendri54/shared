% Scatter plot with option to print smoothed line
%{
%}
classdef ScatterPlot < handle
      
properties
   figS  FigureLH
   % Smoothing method
   smoothingMethod  char = 'rloess';
   smoothingParam   double = 0.2;
   
   % Ignore NaN when plotting?
   ignoreNan  logical = true
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
   
   
   %% Scatter and smooth line
   %{
   Leaves plot open
   %}
   function plot(spS, xV, yV)
      [xSmoothV, ySmoothV] = spS.smooth_line(xV, yV);
%       % *******  Smoothing
%       if spS.ignoreNan
%          idxV = find(~isnan(xV(:))  &  ~isnan(yV(:)));
%          assert(length(idxV) > 2,  'Too few data points');
%          sortM = sortrows([xV(idxV), yV(idxV)]);
%          clear idxV;
%       else
%          assert(~any(isnan(xV(:))),  'NaN x values encountered');
%          assert(~any(isnan(yV(:))),  'NaN y values encountered');
%          sortM = sortrows([xV(:), yV(:)]);
%       end
%       smoothV = smooth(sortM(:,1), sortM(:,2), spS.smoothingParam, spS.smoothingMethod);
      
      
      % *******  Plot
      spS.figS.new;
      hold on;
      iLine = 0;
      
      iLine = iLine + 1;
      spS.figS.plot_scatter(xV, yV, iLine);

      iLine = iLine + 1;
      spS.figS.plot_line(xSmoothV, ySmoothV, iLine);

      hold off;
   end
end
   
end
