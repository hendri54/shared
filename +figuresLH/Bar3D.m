% 3D bar graph
%{
Just a better interface for the matlab bar graph
%}
classdef Bar3D
   
properties
   % Data to plot
   data_xyM    double
   
   % Formatting info
   visible  logical = true
   xLabel   char = 'x';
   yLabel   char = 'y';
   zLabel   char = 'z';
   zLimV    double
   
   % FigureLH object
   figureS    FigureLH
end


methods
   %% Constructor: shows the graph
   function bS = Bar3D(data_xyM, varargin)
      bS.data_xyM = data_xyM;
      [nx, ny] = size(data_xyM);
      
      % Variable arguments
      n = length(varargin);
      for i1 = 1 : 2 : (n - 1)
         bS.(varargin{i1}) = varargin{i1+1};
      end

      bS.figureS = FigureLH('visible', bS.visible, 'figType', 'bar');
      bS.figureS.new;
      
      % Keep in mind that the x axis shows the 2nd dimension of the matrix (!)
      bar3(data_xyM');
      xlabel(bS.xLabel);
      ylabel(bS.yLabel);
      zlabel(bS.zLabel);
      if ~isempty(bS.zLimV)
         zlim(bS.zLimV);
      end
      view([-45, 45]);
      set(gca, 'XTick', 1 : nx);
      set(gca, 'YTick', 1 : ny); 
      bS.figureS.format;
   end
   
   
   %% Save
   function save(bS, figFn, saveFigures)
      bS.figureS.save(figFn, saveFigures);
   end
   
   
   %% Close
   function close(bS)
      bS.figureS.close;
   end
end
   
   
end