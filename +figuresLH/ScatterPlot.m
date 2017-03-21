% Scatter plot with option to print smoothed line
classdef ScatterPlot < handle
      
properties
   figS  FigureLH
   % Smoothing method
   smoothingMethod  char = 'rloess';
   smoothingParam   double = 0.2;
end

methods
   %% Constructor
   %{
   Can pass a FigureLH object, so that properties can be set
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
   
   
   %% Scatter and smooth line
   function plot(spS, xV, yV)
      spS.figS.new;
      hold on;
      iLine = 0;

      sortM = sortrows([xV(:), yV(:)]);
      smoothV = smooth(sortM(:,1), sortM(:,2), spS.smoothingParam, spS.smoothingMethod);
      
      iLine = iLine + 1;
      spS.figS.plot_scatter(sortM(:,1), sortM(:,2), iLine);

      iLine = iLine + 1;
      spS.figS.plot_line(sortM(:,1), smoothV, iLine);

      hold off;
   end
end
   
end
